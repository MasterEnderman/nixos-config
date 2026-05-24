# PAM lives here — not in the home module
{ config, lib, ... }:

{
  options.my.nixos.hyprlock = {
    enable = lib.mkEnableOption "hyprlock PAM authentication";
  };

  config = lib.mkIf config.my.nixos.hyprlock.enable {
    security.pam.services.hyprlock = {};
  };
}
