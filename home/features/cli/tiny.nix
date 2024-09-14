{
  programs.tiny = {
    enable = true;

    settings = {
      servers = [
        {
          addr = "irc.libera.chat";
          join = ["#go-nuts" "#rust"];
          port = 6697;
          tls = true;
          realname = "Vilhelm Bergsøe";
          nicks = ["vilhelmbergsoe"];
        }
      ];
      defaults = {
        nicks = ["vb" "vb"];
        realname = "vb";
        join = [];
        tls = true;
      };
    };
  };
}
