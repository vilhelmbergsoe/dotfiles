## dotfiles

My nixos configuration

## usage

```console
# bootstrap environment
nix-shell
# apply system config
sudo nixos-rebuild switch --flake .#hostname
# if on live medium
nixos-install --flake .#hostname
# home configuration is automagically applied
```
