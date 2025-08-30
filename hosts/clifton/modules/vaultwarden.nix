{config, ...}: {
  services.vaultwarden = {
    enable = true;

    # TODO: configure backup and fix:
    # backup-vaultwarden[506963]: Backup folder '/home/vb/Sync/vaultwarden' does not exist
    # backupDir = "/home/vb/Sync/vaultwarden";
    environmentFile = "/home/vb/Sync/vaultwarden/env";

    config = {
      SIGNUPS_ALLOWED = false;

      DOMAIN = "https://vault.bergsoe.net";

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;

      # local postfix
      SMTP_HOST = "127.0.0.1";
      SMTP_PORT = 25;
      SMTP_SSL = false;

      SMTP_FROM = "no-reply@bergsoe.net";
      SMTP_FROM_NAME = "Vaultwarden";
    };
  };

  services.postfix = {
    enable = true;

    settings.main = {
      myorigin = "bergsoe.net";

      myhostname = "bergsoe.net";

      mydestination = [];
      mynetworks = [ "127.0.0.0/8" "[::1]/128" ];
    };
  };
}
