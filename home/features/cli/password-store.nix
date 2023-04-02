{
  programs.password-store = {
    enable = true;

    settings = {
      PASSWORD_STORE_DIR = "/home/vb/Sync/.password-store";
      PASSWORD_STORE_KEY = "vilhelmbergsoe@gmail.com";
      PASSWORD_STORE_CLIP_TIME = "60";
    };
  };

  # programs.bash.sessionVariables = {
  #   "PASSWORD_STORE_DIR" = "/home/vb/Sync/.password-store";
  #   "PASSWORD_STORE_KEY" = "vilhelmbergsoe@gmail.com";
  # };
}
