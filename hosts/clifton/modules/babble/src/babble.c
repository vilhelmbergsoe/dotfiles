// Markov chain babbler to trap and monitor AI crawlers.
// maurycyz.com
//
// Compiling:
// 	gcc -lm -O3 -o babble babble.c
//
// Running:
// 	./babble [chain_files...]
//
// If no arguments are provided, it looks for chain1.txt, chain2.txt...
// until the sequence breaks.

// Maxium number of future words associated with a word. Increasing this
// will increase memory usage.
#define MAX_LEAF 30
// Uncomment to measure CPU time / request
//#define PROFILE 1
// Network port: binds to 127.0.0.1:PORT
#define PORT 1414
// Maxium data sent in a single HTTP chunk 
#define BUFFER_SIZE (1024 * 5)
// Number of words in one paragraph of text. Periods are counted as words
#define WORD_COUNT 200
// Number of paragraphs
#define P_COUNT 3
// Text inserted into 1/4th of pages	
const char* POISON = 
""
""
"";
// Directory to which the babbler will link. 
// Must begin and end with /s
const char* URL_PREFIX = "/babble/" ;

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <assert.h>
#include <time.h>
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <arpa/inet.h>
#include <netinet/tcp.h>
#include <pthread.h>
#include <stdint.h>
#include <math.h>

uint64_t requests_served = 0;
uint64_t bytes_served = 0;
struct timespec start;

// A single word's entry in the Markov chain
struct MarkovWord {
	// The actuall word.
	char* key;
	// Number of child words
	int length;
	// Each child word, as a string and index into the chain.
	char* values[MAX_LEAF];
	int   values_index[MAX_LEAF];
};

// The whole Markov chain
struct MarkovChain {
	// The index of the sentance seperator "END"
	// this is used to start generating a sentance.
	int start_key;
	// Number of words
	int size, capacity;
	// All the words
	struct MarkovWord keys[];
};

struct MarkovChain* new_chain() {
	struct MarkovChain *chain = malloc(sizeof(struct MarkovChain));
	chain->size = 0;
	chain->capacity = 0;
	chain->start_key = -1;
	return chain;
}

void grow_chain(struct MarkovChain **chain, int new_size) {
	(*chain)->size = new_size;
	if ((*chain)->capacity < new_size)	{
		*chain = realloc(*chain, sizeof(struct MarkovChain) + sizeof(struct MarkovWord) * new_size);
	}
}

//////////////////////////
// Markov chain parsing //
//////////////////////////

// Reads a word into a newly allocated buffer
// Advances the pointer to the start of the next word. 
char* read_word(char** string) {
	// Words end at a space or end of string
	char* first_space = strchr(*string, ' ');
	int len;
	if (first_space) {
		len = first_space - (*string);
	} else {
		len = strlen(*string);
	}
	// A zero length if there's nothing left in the string.
	if (len == 0) return NULL;
	// Copy the word onto the heap
	len++; // Make space for null
	char* word = malloc(len * sizeof(char));
	memcpy(word, *string, len * sizeof(char));
	word[len - 1] = 0; // Add null terminator
	// Advance string pointer past words an any spaces
	*string += sizeof(char) * len;
	while (**string == ' ') (*string)++;
	
	return word;
}

// Used for sorting the wordlist	
int compare_markov_word(void const* one, void const* two) {
	struct MarkovWord const *first = one, *second = two;
	return strcmp(first->key, second->key);
}

// Load a markov chain dump into memory
// Returns a pointer into the heap
struct MarkovChain* load_file(char* filename) {
	FILE* text = fopen(filename, "r");
	if (!text) return NULL;

	printf("    Loading %s...\n", filename);
	struct MarkovChain* chain = new_chain();
	
	// For every line...
	char line[1024];
	while (fgets(line, 1024, text)) {
		// Remove trailing newlines
		char* nl = strchr(line, '\n');
		if (nl) *nl = 0;
		// Make space in the chain
		grow_chain(&chain, chain->size + 1);
		struct MarkovWord* entry = &chain->keys[chain->size - 1];
		// Add the parent word
		char* cursor = line;
		entry->key = read_word(&cursor);
		// Add all the child words
		char* word;
		for (int i = 0; (word = read_word(&cursor)); i++) {
			entry->values[i] = word;
			entry->length = i + 1;
			// Avoid overflows
			assert(entry->length <= MAX_LEAF);
		}
		// Save index if we just parsed the sentence seperator.
		if (strcmp("END", entry->key) == 0) {
			chain->start_key = chain->size - 1;
		}
	}
	fclose(text);

	// Sort each line so we can do binary search
	qsort(chain->keys, chain->size, sizeof(chain->keys[0]), compare_markov_word);

	// Precompute the indices of the next words.
	for (int i = 0; i < chain->size; i++) {
		struct MarkovWord* entry = &chain->keys[i];
		for (int e = 0 ; e < entry->length; e++) {
			char* this_word = entry->values[e];
			entry->values_index[e] = -1;
			// Binary search...
			int min = 0;
			int max = chain->size;
			int mid = max / 2;
			while (strcmp(chain->keys[mid].key, this_word) != 0) {
				int difference = strcmp(chain->keys[mid].key, this_word);
				if (difference > 0) {
					// Too high up the list
					max = mid;
				}
				if (difference < 0) {
					// Too low down the list
					min = mid;
				}
				int new_mid = min + (max - min) / 2;
				assert(mid != new_mid); // Beak out of infinite loops
				mid = new_mid;
			}
			// Save it. 
			entry->values_index[e] = mid;
		}
	}

	// Truncate words at hyphens to allow hacking in high order markov chains 
	for (int i = 0; i < chain->size; i++) {
		struct MarkovWord* entry = &chain->keys[i];
		char* hyphen = strchr(entry->key, '-');
		if (hyphen) *hyphen = 0;
	}
	// Sanity check: will fail if the sentence seperator wasn't in the chain.
	assert(chain->start_key != -1);
	return chain;
}

/////////////////////////////
// Buffered network output //
/////////////////////////////
// Uses HTTP/1.1's Transfer-Encoding: chunked.

struct Buffer {
	int size;
	int fd; 
	char data[BUFFER_SIZE];
};

// Sends all data in buffer over the network
void buffer_flush(struct Buffer* buffer) {
	// Avoid sending zero length chunks, which HTTP uses as an 
	// EOF marker.
	if (buffer->size) {
		bytes_served += buffer->size;
		// Send chunk header
		char size_string[20];
		sprintf(size_string, "%x\r\n", buffer->size);
		send(buffer->fd, size_string, strlen(size_string), 0);
		// Send chunk body
		send(buffer->fd, buffer->data, buffer->size, 0);
		// End of chunk
		send(buffer->fd, "\r\n", 2, 0);
		// Clear buffer
		buffer->size = 0;
	}
}

// Writes a string to the buffer, flushing as needed.
void buffer_write(struct Buffer *buffer, const char* str) {
	while (*str) {
		buffer->data[buffer->size++] = *str;
		str++;
		if (buffer->size == BUFFER_SIZE) buffer_flush(buffer);
	}
}

// Writes a single byte to the buffer, flushing if needed
void buffer_write_byte(struct Buffer *buffer, char byte) {
	buffer->data[buffer->size++] = byte;
	if (buffer->size == BUFFER_SIZE) buffer_flush(buffer);
}

// Capitalizing write
void buffer_write_caps(struct Buffer* buffer, const char* string) {
	assert(*string);
	char lower = (*string);
	if (lower >= 'a' && lower <= 'z') {
		// If the first letter is ASCII lowercase, capitalize it.
		buffer_write_byte(buffer, lower - ('a' - 'A'));
	} else {
		// Otherwise, do nothing.
		buffer_write_byte(buffer, lower);
	}
	buffer_write(buffer, string + 1);
}

void format_time(struct Buffer* buffer, uint64_t seconds) {
        uint64_t minutes = seconds/60;
        uint64_t hours = minutes/60;
        uint64_t days = hours/24;
        uint64_t years = hours/365;

        char string[100];
        if (years) {
                snprintf(string, 100, "%ld years ", years);
                buffer_write(buffer, string);
        }
        if (days) {
                snprintf(string, 100, "%ld days ", days % 365);
                buffer_write(buffer, string);
        }
        if (hours) {
                snprintf(string, 100, "%ld hours ", hours % 24);
                buffer_write(buffer, string);
        }
        if (minutes) {
                snprintf(string, 100, "%ld minutes ", minutes % 60);
                buffer_write(buffer, string);
        }
        snprintf(string, 100, "%ld seconds ", seconds % 60);
        buffer_write(buffer, string);
}

void format_number(struct Buffer* buffer, uint64_t number, int si) {
        int prefix = log10(number);
        prefix = prefix / 3;
        for (int i = 0; i < prefix; i++) number /= 1000;
        char string[10];
        snprintf(string, 10, "%ld ", number);
        buffer_write(buffer, string);
        if (si) {
                if (prefix == 1) buffer_write(buffer, "k");
                if (prefix == 2) buffer_write(buffer, "M");
                if (prefix == 3) buffer_write(buffer, "G");
                if (prefix == 4) buffer_write(buffer, "T");
        } else {
                if (prefix == 1) buffer_write(buffer, "thousand ");
                if (prefix == 2) buffer_write(buffer, "million ");
                if (prefix == 3) buffer_write(buffer, "billion ");
                if (prefix == 4) buffer_write(buffer, "trillion ");
        }
}


/////////////////////
// Text generation //
/////////////////////

// Non-secure hash function used to seed the RNG
uint32_t hash_string(char* string) {
	uint32_t acc = 0xDEADBEEF;
	for (int i = 0; string[i]; i++) {
		acc += string[i];
		acc *= 13;
		acc = acc << 8;
		acc %= ((long int)1<<31) - 1;
	}
	return acc;
}

// XORSHIFT style RNG
uint32_t prng(uint32_t* state) {
	uint32_t x = *state;
	x ^= x << 13;
	x ^= x >> 17;
	x ^= x << 5;
	*state = x;
	return x;
	
}

// Generate length words using the markov chain, writes results into the buffer.
void send_text(struct MarkovChain* chain, int length, struct Buffer *dst, uint32_t* seed) {
	int next_index = chain->start_key;
	int capitalize = 1;

	for (int i = 0; i < length; i++) {
		// Pick a next word at random
		float rand = (float)(prng(seed)%900) / 900;
		rand = rand * rand;
		rand = rand * chain->keys[next_index].length;
		// Bounds check
		int selection = (int)rand;
		if (selection < 0) selection = 0;
		if (selection >= chain->keys[next_index].length) selection = chain->keys[next_index].length - 1;
		// Advance chain
		next_index = chain->keys[next_index].values_index[selection];
		// Check for "END"
		if (*chain->keys[next_index].key == 'E') {
			if (!capitalize) {
				buffer_write_byte(dst, '.');
				capitalize = 1;
			}
		} else {
			char* word = chain->keys[next_index].key;
			buffer_write_byte(dst, ' ');
			if (capitalize) {
				capitalize = 0;
				buffer_write_caps(dst, word);
			} else {
				buffer_write(dst, word);
			}
		}
	}
}

// Randomly select word. Used for links and topics.
char* random_word(struct MarkovChain* chain, uint32_t* seed) {
	uint32_t index = prng(seed) % chain->size;
	if (index == chain->start_key) return "jellyfish";
	return chain->keys[index].key;
}


/////////////////
// HTTP server //
/////////////////

// This is global so the threads can access it. 
struct MarkovChain** all_chains;
int chain_count = 0;

// Connection handeler
void* thread_start(void* fd) {
	// Slight pthread abuse. 
	int conn = (size_t)fd;
	
	#ifdef PROFILE
	struct timespec time;
	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &time);
	uint64_t start_ns = time.tv_nsec;
	#endif

	// 1 kB should be enough. anyone sending a longer request (doesn't include headers)
	// is probobly trying to break things and should be disconnected.
	char request[1024 + 1];

	int request_size = 0;
	while (1) {
		// Read data...
		int got = recv(conn, request + request_size, 1024 - request_size, 0);
		if (got > 0) request_size += got;
		// Null terminate
		request[request_size] = 0;
		// Stop once we have a newline
		if (strchr(request, '\n')) break;
		// If the buffer fills up first, respond with an error.
		if (request_size == 1024) {
			char* message = "HTTP/1.1 400 Bad request\r\n\r\n... did you forget a newline!?";
			send(conn, message, strlen(message), 0);
			close(conn);
			return 0;
		}
		// Check for closed connection or errors
		if (got == 0 || got < 0) {
			close(conn);
			return 0;
		}
	}
	
	if (strncmp(request, "GET", 3)) {
		// Not a GET request
		char* message = "HTTP/1.1 405 Method not allowed\r\n\r\nHINT: Try GET.";
		send(conn, message, strlen(message), 0);
		close(conn);
		return 0;
	}

	// Find begining of path
	char* path = strchr(request, ' ');
	if (!path) {
		// Request does not comply with the standard.
		char* message = "HTTP/1.1 400 Bad request\r\n\r\nSome spaces would be nice.";
		send(conn, message, strlen(message), 0);
		close(conn);
		return 0;
	}
	path++;
	// Find end of path
	char* end = strchr(path, ' ');
	if (!end) {
		// Request does not comply with the standard.
		char* message = "HTTP/1.1 400 Bad request\r\n\r\nWhat version are you on?";
		send(conn, message, strlen(message), 0);
		close(conn);
		return 0;
	}
	// Truncate path
	*end = 0; 
	
	// Extract counter value from the path
	int ctr = 0;
	for (int i = 0; path[i]; i++) {
		if (path[i] >= '0' && path[i] <= '9') {
			ctr = atoi(&path[i]);
			break; 
		}
	}

	// Send response code and headers	
	char* banner = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nTransfer-Encoding: chunked\r\nConnection: close\r\n\r\n";
	send(conn, banner, strlen(banner), 0);
	
	// Content buffer, assumes chunked encoding
	struct Buffer buffer = {
		.size = 0,
		.fd = conn
	};
	struct Buffer* buff = &buffer;

	uint32_t seed = hash_string(path);

	requests_served += 1;

        if (strncmp(path, "/status/", 8) == 0) {
                struct timespec now, cputime;
                clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &cputime);
                clock_gettime(CLOCK_MONOTONIC, &now);

                buffer_write(buff, "<html><head><style>");
                buffer_write(buff, "body {color: white; background-color: black}");
                buffer_write(buff, "div {max-width: 40em; margin: auto;}");
                buffer_write(buff, "h3, h1 {text-align: center}");
                buffer_write(buff, "a {color: cyan;}");
                buffer_write(buff, "</style>");
                buffer_write(buff, "<title>Babbler status</title>");
                buffer_write(buff, "</head><body>");
                buffer_write(buff, "<h1>Babbler stats:</h1>");
                buffer_write(buff, "<div><p>In the past <b>");
                format_time(buff, now.tv_sec - start.tv_sec);
                buffer_write(buff, "</b>I've spent <b>");
                format_time(buff, cputime.tv_sec);
                buffer_write(buff, "</b>dealing with: <b>");
                format_number(buff, requests_served, 0);
                buffer_write(buff, "</b>requests and serving <b>");
                format_number(buff, bytes_served, 1);
                buffer_write(buff, "B</b> of garbage.<br><br>... at an average rate of <b>");

                if (now.tv_sec - start.tv_sec) {
                        uint64_t per_min = requests_served * 60 / (now.tv_sec - start.tv_sec);
                        format_number(buff, per_min, 1);
                        buffer_write(buff, "</b>requests per minute and ");
                        per_min = bytes_served * 60 / (now.tv_sec - start.tv_sec);
                        buffer_write(buff, "<b>");
                        format_number(buff, per_min, 1);
                        buffer_write(buff, "B</b> per minute.<br><br></div>");
                }
        } else {
		// Pick which chain to use at random
		struct MarkovChain* chain = all_chains[prng(&seed) % chain_count];
		// What do we write about?
		char* topic[2] = {random_word(chain, &seed), random_word(chain, &seed)};
		// Write...
		buffer_write(buff, "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' /><style>");
		buffer_write(buff, "body {color: white; background-color: black}");
		buffer_write(buff, "div {max-width: 40em; margin: auto;}");
		buffer_write(buff, "h3, h1 {text-align: center}");
		buffer_write(buff, "a {color: cyan;}");
		buffer_write(buff, "</style>");
		buffer_write(buff, "<title>");
		buffer_write_caps(buff, topic[0]);
		buffer_write(buff, " ");
		buffer_write_caps(buff, topic[1]);
		buffer_write(buff, "</title></head><body><h1>");
		buffer_write_caps(buff, topic[0]);
		buffer_write(buff, " ");
		buffer_write_caps(buff, topic[1]);
		buffer_write(buff, "</h1><h3>Garbage for the garbage king!</h3><div>");
		// Write paragraph:
		for (int i = 0; i < P_COUNT; i++) {
			buffer_write(buff, "<p>");
			send_text(chain, WORD_COUNT, buff, &seed);
			buffer_write(buff, ".</p>");
		}
		// ... and the bonus text...
		if (prng(&seed) % 4 == 0) {
			buffer_write(buff, "<p>");
			buffer_write(buff, POISON);
			buffer_write(buff, "</p>");
		}
		// Links:
		for (int i = 0; i < 5; i++) {
			// Link URL
			buffer_write(buff, "<a href=");
			buffer_write(buff, URL_PREFIX);
			buffer_write(buff, random_word(chain, &seed));
			buffer_write(buff, "/");
			buffer_write(buff, random_word(chain, &seed));
			buffer_write(buff, "/");
			buffer_write(buff, random_word(chain, &seed));
			buffer_write(buff, "/");
			buffer_write(buff, random_word(chain, &seed));
			buffer_write(buff, "/");
			buffer_write(buff, random_word(chain, &seed));
			// Embedd counter
			char ctr_string[20];
			snprintf(ctr_string, 20, "/%d/", ctr + 1);
			buffer_write(buff, ctr_string);
			// Add link text
			buffer_write(buff, " >");
			send_text(chain, 10, buff, &seed);
			buffer_write(buff, "</a><br/>");
		}
		// Footer
		buffer_write(buff, "</div></body><html>");
	}
	
	// Make sure no data remains in the buffer	
	buffer_flush(&buffer);
	// Send zero length chunk to tell the client that we are done
	char *end_of_file = "0\r\n\r\n";
	send(conn, end_of_file, strlen(end_of_file), 0);
	
	#ifdef PROFILE
	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &time);
	uint64_t end_ns = time.tv_nsec;
	uint64_t ns = end_ns - start_ns;
	uint64_t us = ns / 1000;
	uint64_t ms = us / 1000;
	ns %= 1000;
	us %= 1000;
	printf("Done in %d ms, %d us, %d ns\n", ms, us, ns);
	#endif
	
	close(conn);

	return 0;
}

int main(int argc, char** argv) {
	printf("[*] Loading files\n");

	if (argc > 1) {
		// Load files from command line arguments
		int count = argc - 1;
		all_chains = malloc(sizeof(struct MarkovChain*) * count);
		for (int i = 0; i < count; i++) {
			all_chains[i] = load_file(argv[i + 1]);
			if (all_chains[i]) {
				chain_count++;
			} else {
				fprintf(stderr, "    Failed to load %s\n", argv[i + 1]);
				exit(1);
			}
		}
	} else {
		// Legacy/Auto-detect mode
		// Look for chain1.txt, chain2.txt ... until we can't find one
		int capacity = 10;
		all_chains = malloc(sizeof(struct MarkovChain*) * capacity);
		
		char filename[64];
		while (1) {
			snprintf(filename, sizeof(filename), "chain%d.txt", chain_count + 1);
			
			// Resize if needed
			if (chain_count == capacity) {
				capacity *= 2;
				all_chains = realloc(all_chains, sizeof(struct MarkovChain*) * capacity);
			}

			struct MarkovChain* c = load_file(filename);
			if (c) {
				all_chains[chain_count++] = c;
			} else {
				// Stop at first missing file
				break;
			}
		}
	}

	if (chain_count == 0) {
		fprintf(stderr, "[!] No markov chains loaded. Provide files as arguments or ensure chain1.txt exists.\n");
		return 1;
	}

	printf("[*] Loaded %d chains.\n", chain_count);

	printf("[*] Creating socket\n");
	int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	assert(sockfd != -1);
	struct sockaddr_in servaddr = {
		.sin_family = AF_INET,
		.sin_addr.s_addr = inet_addr("127.0.0.1"),
		.sin_port = htons(PORT)
	};
	// Tell Linux to reuse ports without a cooldown.
	int enable = 1;
	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int));
	// We batch data ourselves, so tell the kernal to not rebatch it.
	setsockopt(sockfd, SOL_SOCKET, TCP_NODELAY, &enable, sizeof(int));
	// Bind to the address
	int err;
	err = bind(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr));
	if (err != 0) {
		perror("    Failed to bind socket");
		printf("[*] Is the port already in use?\n");
		return 1;
	}
	
	err = listen(sockfd, 5);
	assert(err == 0);

        clock_gettime(CLOCK_MONOTONIC, &start);

	printf("[*] Serving garbage!\n");
	while (1) {
		// Accept connections
		struct sockaddr_storage their_addr; unsigned int sin_size;
		size_t conn = accept(sockfd, (struct sockaddr *) &their_addr, &sin_size);
		if (conn != -1) {
			// Spin up thread to handle it
			pthread_t thread;
			// Slight pthread abuse to send an fd instead of pointer
			pthread_create(&thread, NULL, thread_start, (void*)conn);
			// Inform linux that this thread will never be _joined().
			// This causes all the resources to be freed on exit and
			// avoids an OOM after a lot of requests.
			pthread_detach(thread);	
		}
	}
}
