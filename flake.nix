{
  description = "My nix configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # agenix
    agenix.url = "github:ryantm/agenix";

    # Doom emacs
    doom-emacs.url = "github:nix-community/nix-doom-emacs";

    # Hardware quirks
    hardware.url = "github:nixos/nixos-hardware";

    # Site
    site.url = "github:vilhelmbergsoe/site";

    # Minecraft Server
    nix-minecraft.url = "github:misterio77/nix-minecraft";
  };

  outputs = {
    self,
    agenix,
    nixpkgs,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    inherit (self) outputs;
  in rec {
    overlays = import ./overlays {inherit inputs;};

    # Devshell for bootstrapping
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./shell.nix {inherit pkgs;});

    nixosConfigurations = {
      # Home Server
      clifton = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        }; # Pass flake inputs to our config
        modules = [./hosts/clifton agenix.nixosModules.default];
      };
      # Desktop Computer
      buckbeak = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        }; # Pass flake inputs to our config
        modules = [./hosts/buckbeak agenix.nixosModules.default];
      };
    };
  };
}
