import sys

# Usage: python3 process.py <input_file> <output_file>

# One works well for short bodies of text. 
# Two needs ~10,000 words to work well.
context_length = 2

def multigram(words):
    """Join words with hyphens in reverse order"""
    return "-".join(words[::-1])    

def get_words(filename):
    """Extract words from a file, replacing periods with "END"."""
    print(f"Reading {filename} ...")
    try:
        with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
            for line in f:
                for word in line.split(" "):
                    has_period = '.' in word
                    if ("-" in word): continue
                    if ("'" in word): continue
                    word = word.strip(";:.!?\n“”\"[]-()_0123456789 ")
                    word = word.lower()
                    if (len(word) > 0): yield word
                    if has_period: yield "END"
        # Pad end of file
        for i in range(context_length): yield "END"
    except Exception as e:
        print(f"Error reading file: {e}")

def make_chain(filename):
    chain = {}
    starters = {}

    def add_chunk(words):
        # Split into lists of size context_length
        prev = multigram(words[:-1])
        now = multigram(words[1:])

        # Record
        if prev not in chain: chain[prev] = {}
        if now not in chain[prev]: chain[prev][now] = 1
        else: chain[prev][now] += 1

        # If this is the start of a sentence, record it
        if prev.startswith("END"):
            if prev not in starters: starters[prev] = 1
            else: starters[prev] += 1

    print("[*] Generating markov chain...")
    chunk = ["END"] * (context_length + 1)
    
    for word in get_words(filename):
        chunk = chunk[1:]
        chunk.append(word)
        add_chunk(chunk)

    print(f"[*] Chain size: {len(chain)}")

    if 'END' not in chain:
        chain["END"] = starters

    print("[*] Converting...")
    dump = ""
    for word1 in sorted(chain.keys()):
        prob = []
        if word1 in chain:
            for word2 in chain[word1].keys():
                prob.append((word2, chain[word1][word2]))
            prob.sort(key=lambda point: point[1], reverse = True)
            sort = [point[0] for point in prob]
            if len(sort) > 30: sort = sort[:30]
            dump += word1 + " " + " ".join(sort) + "\n"
    
    return dump

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 process.py <input> <output>")
        sys.exit(1)
        
    in_file = sys.argv[1]
    out_file = sys.argv[2]
    
    result = make_chain(in_file)
    
    with open(out_file, 'w', encoding='utf-8') as f:
        f.write(result)
