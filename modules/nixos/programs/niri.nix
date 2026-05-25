{ config, lib, ... }:

{
  options.my.nixos.niri = {
    enable = lib.mkEnableOption "niri wayland compositor";
  };

  config = lib.mkIf config.my.nixos.niri.enable {
    programs.niri.enable               = true;
    hardware.graphics.enable             = true;
    programs.xwayland.enable = true;
  };
}
