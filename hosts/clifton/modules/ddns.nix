{config, ...}: {
  config = {
    age.secrets.apikey.file = ../secrets/apikey.age;

    services.cloudflare-dyndns = {
      # fix this
      enable = true;
      # records = [ "bergsoe.net" ];
      domains = ["bergsoe.net"];
      # email = "vilhelmbergsoe@gmail.com";
      # apikeyFile = config.age.secrets.apikey.path;
      apiTokenFile = config.age.secrets.apikey.path;
    };
  };

  # options = {
  # };
}
