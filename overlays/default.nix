{inputs}: {
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs
      (_: flake: (flake.packages or flake.legacyPackages or {}).${final.system} or {})
      inputs;
  };

  modifications = final: prev: {
    spectrwm = prev.spectrwm.overrideAttrs (_old: {
      src = final.fetchFromGitHub {
        owner = "conformal";
        repo = "spectrwm";
        rev = "efc458e";
        sha256 = "sha256-aDyWMh2xhSnaJyXYrbw88myQidb7ab6N62PM2SrScs0=";
      };
    });
  };
}
