{ ... }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Vilhelm Bergsøe";
        email = "vilhelm@bergsoe.net";
      };
      revset-aliases = {
	# Only trunk (main/master) and tags are immutable
	"immutable_heads()" = "present(trunk()) | tags()";

	# Finds the nearest bookmark behind a given revision (used by tug)
        "closest_bookmark(to)" = "heads(::to & bookmarks())";

	# Show full path from trunk to current change in jj log
	"default()" = "trunk()::@";
      };
      aliases = {
        tug = ["bookmark" "move" "--from" "closest_bookmark(@-)" "--to" "@-"];
      };
      git = {
        write-change-id-header = true;
      };
      signing = {
        sign-all = true;
        backend = "ssh";
        key = "~/.ssh/id_rsa.pub";
      };
    };
  };
}
