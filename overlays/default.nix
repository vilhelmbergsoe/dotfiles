{inputs}: {
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs
      (_: flake: (flake.packages or flake.legacyPackages or {}).${final.system} or {})
      inputs;
  };

  modifications = final: prev: {
	#    spectrwm = prev.spectrwm.overrideAttrs (old: {
	#      src = final.fetchFromGitHub {
	#        owner = "conformal";
	#        repo = "spectrwm";
	# version = "3.6.0";
	#
	#        rev = "SPECTRWM_3_6_0";
	#        sha256 = "sha256-Dnn/iIrceiAVuMR8iMGcc7LqNhWC496eT5gNrYOInRU=";
	#      };
	#
	#      buildInputs = old.buildInputs ++ [ prev.libbsd ];
	#    });

    # linuxPackages.rtl88xxau-aircrack = prev.linuxPackages.rtl88xxau-aircrack.overrideAttrs (_old: {
    #   src = final.fetchFromGitHub {
    #     owner = "aircrack-ng";
    #     repo = "rtl8812au";
    #     rev = "35308f4";
    #     sha256 = "sha256-QcEwFg9QTi+cCl2JghKOzEZ19LP/ZFMbZJAMJ0BLH9M=";
    #   };
    # });
  };
}
