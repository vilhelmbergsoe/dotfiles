{
  lib,
  config,
  ...
}: {
  imports = [
    ./lualine.nix
    ./staline.nix
  ];

  options = {
    statusline.enable = lib.mkEnableOption "Enable statusline module";
  };
  config = lib.mkIf config.dap.enable {
    lualine.enable = lib.mkDefault true;
    staline.enable = lib.mkDefault false;
  };
}
