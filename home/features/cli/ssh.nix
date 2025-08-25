{
  programs.ssh = {
    enable = true;

    # extraConfig = ''
    # Host github.com
    #     Hostname ssh.github.com
    #     Port 443
    #     User git
    # '';
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
    };
  };
}
