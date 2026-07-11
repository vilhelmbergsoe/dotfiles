{
  services.gotosocial = {
    enable = true;
    settings = {
      application-name = "gotosocial";
      host = "bergsoe.net";

      bind-address = "127.0.0.1";
      port = 8081;
      protocol = "https";

      db-address = "/var/lib/gotosocial/database.sqlite";
      db-type = "sqlite";
      storage-local-base-path = "/var/lib/gotosocial/storage";

      accounts-registration-open = true;
      
      smtp-host = "127.0.0.1";
      smtp-port = 25;
      smtp-from = "no-reply@bergsoe.net";
    };
  };
}
