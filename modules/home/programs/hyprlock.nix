{ config, lib, ... }:

{
  options.my.home.hyprlock = {
    enable = lib.mkEnableOption "hyprlock screen lock";
  };

  config = lib.mkIf config.my.home.hyprlock.enable {
    programs.hyprlock.enable       = true;
    stylix.targets.hyprlock.enable = true;
  };
}
