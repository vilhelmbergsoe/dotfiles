{ config, lib, pkgs, ... }:

let
  cfg = config.services.babble;

  babble = pkgs.stdenv.mkDerivation {
    name = "babble-server";
    
    src = ./src;

    nativeBuildInputs = [ pkgs.gcc pkgs.python3 ];

    trainingFiles = cfg.trainingFiles;

    buildPhase = ''
      gcc -O3 -pthread -lm -o babble babble.c

      mkdir -p chains
      
      counter=1
      for file in $trainingFiles; do
        echo "Processing $book -> chains/chain$counter.txt"
        python3 process.py "$file" "chains/chain$counter.txt"
        counter=$((counter+1))
      done
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/babble
      
      cp babble $out/bin/
      
      cp chains/*.txt $out/share/babble/
    '';
  };

in {
  options.services.babble = {
    enable = lib.mkEnableOption "Babble Markov Chain Trap";

    trainingFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
      description = "List of RAW text files to train the Markov chain on.";
      example = [ ./books/moby_dick.txt ./logs/access.log ];
    };
  };

  config = lib.mkIf cfg.enable {
    # We need at least one file
    assertions = [{
      assertion = (builtins.length cfg.trainingFiles) > 0;
      message = "Babble service requires at least one text file in 'trainingFiles' to generate chains.";
    }];

    systemd.services.babble = {
      description = "Babble Crawler Trap";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${babble}/bin/babble";
        # The C code looks for chainX.txt in the CWD
        WorkingDirectory = "${babble}/share/babble";
        
        Restart = "always";
        RestartSec = "5s";
        
        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
      };
    };
  };
}
