{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      # https://paper-chan.moe/paper-optimization
      # make sure /srv/minecraft/survival/ exists and is owned by minecraft user
      "survival" = {
        enable = true;

        package = pkgs.inputs.nix-minecraft.paperServers.paper-1_19_4;
        jvmOpts = (import ./aikar-flags.nix) "2G";
        serverProperties = {
          server-port = 25565;
          view-distance = 10;
          simulation-distance = 10;
          allow-flight = true;
        };
        files = {
          "ops.json".value = [
            {
              uuid = "d2c7cb0f-9d44-4fc4-9592-9d29d7353974";
              name = "sconces";
              level = 4;
            }
            {
              uuid = "9f4357b5-4d16-4b5b-ad04-bab2c0d577e0";
              name = "182k";
              level = 4;
            }
          ];
          "bukkit.yml".value = {
            spawn-limits = {
              monsters = 56;
              animals = 10;
              water-animals = 5;
              water-ambient = 20;
              water-underground-creature = 5;
              axolotls = 5;
              ambient = 15;
            };
          };
          "spigot.yml".value = {
            mob-spawn-range = 7;
            view-distance = "default";
            simulation-distance = "default";
            entity-tracking-range = {
              players = 48;
              animals = 48;
              monsters = 48;
              misc = 32;
              other = 64;
            };
            entity-activation-range = {
              animals = 32;
              monsters = 32;
              raiders = 48;
              misc = 16;
              water = 16;
              villagers = 32;
              flying-monsters = 32;
              wake-up-inactive = {
                animals-max-per-ticket = 4;
                animals-every = 1200;
                animals-for = 100;
                monsters-max-per-tick = 8;
                monsters-every = 400;
                monsters-for = 100;
                villagers-max-per-tick = 4;
                villagers-every = 400;
                villagers-for = 100;
                flying-monsters-max-per-tick = 8;
                flying-monsters-every = 200;
                flying-monsters-for = 100;
              };
              villagers-work-immunity-after = 100;
              villagers-work-immunity-for = 20;
              villagers-active-for-panic = true;
              tick-inactive-villagers = true;
              ignore-spectators = false;
            };
          };
          "config/paper-world-defaults.yml".value = {
            despawn-ranges = {
              ambient.hard = 128;
              ambient.soft = 32;
              axolotols.hard = 128;
              axolotols.soft = 32;
              creature.hard = 128;
              creature.soft = 32;
              misc.hard = 128;
              misc.soft = 32;
              monster.hard = 128;
              monster.soft = 32;
              underground_water_creature.hard = 128;
              underground_water_creature.soft = 32;
              water_ambient.hard = 64;
              water_ambient.soft = 32;
              water_creature.hard = 128;
              water_creature.soft = 32;
            };
            max-entity-collisions = 6;
            per-player-mob-spawns = true;
            prevent-moving-into-unloaded-chunks = true;
            redstone-implementation = "alternate-current"; # change to "vanilla" if something doesn't work
          };
          "config/paper-global.yml".value = {
            chunk-loading = {
              autoconfig-send-distance = true;
              enable-frustum-priority = false;
              global-max-chunk-load-rate = "-1.0";
              global-max-chunk-send-rate = "-1.0";
              global-max-concurrent-load = 500.0;
              max-concurrent-sends = 2;
              min-load-radious = 2;
              player-max-chunk-load-rate = "-1.0";
              player-max-concurrent-loads = 20.0;
              target-player-chunk-send-rate = 100.0;
            };
          };
        };
        symlinks = {
          "plugins/Chunky.jar" = pkgs.fetchurl rec {
            pname = "Chunky";
            version = "1.3.52";
            url = "https://dev.bukkit.org/projects/chunky-pregenerator/files/4175725/download";
            sha256 = "1g2irl3krmhmccmsmrjn8jm1yz5wg1rfh981vki14mq08sxsmwjh";
          };
          "plugins/Spark.jar" = pkgs.fetchurl rec {
            pname = "Spark";
            version = "1.10.37";
            url = "https://ci.lucko.me/job/spark/375/artifact/spark-bukkit/build/libs/spark-1.10.37-bukkit.jar";
            sha256 = "1ja8vl40sj45xq475h2ba654zfcnqa71642ldzzkawnf0flgkl09";
          };
          "plugins/TreeAssist.jar" = pkgs.fetchurl rec {
            pname = "TreeAssist";
            version = "7.3.34";
            url = "https://dev.bukkit.org/projects/tree-assist/files/3963990/download";
            sha256 = "0017ii41z7i7v4vpznndrww1vcspvjgqlw467wm7swhc08mya60g";
          };
        };
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [25565];
    allowedUDPPorts = [25565 19132];
  };
}
