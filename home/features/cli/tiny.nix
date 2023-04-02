{
  programs.tiny = {
    enable = true;

    settings = {
      servers = [
        {
          addr = "irc.libera.chat";
          port = 6697;
          tls = true;
          realname = "Vilhelm Bergsøe";
          nicks = ["vilhelmbergsoe" "vb"];
        }
      ];
      defaults = {
        nicks = ["vilhelmbergsoe" "vb"];
        realname = "Vilhelm Bergsøe";
        join = ["#go-nuts" "#rust"];
        tls = true;
      };
    };
  };
}
