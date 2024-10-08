{
  description = "My nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # Hardware quirks
    hardware.url = "github:nixos/nixos-hardware";

    # Site
    site.url = "github:vilhelmbergsoe/site";

    # Minecraft Server
    nix-minecraft.url = "github:misterio77/nix-minecraft";
  };

  outputs = {
    self,
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
        modules = [ ./hosts/clifton ];
      };
      # Desktop Computer
      buckbeak = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        }; # Pass flake inputs to our config
        modules = [ ./hosts/buckbeak ];
      };
    };
  };
}
