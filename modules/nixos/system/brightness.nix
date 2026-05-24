{ config, lib, pkgs, ... }:

{
  options.my.nixos.brightness = {
    enable = lib.mkEnableOption "brightness control";
  };

  config = lib.mkIf config.my.nixos.brightness.enable {
    hardware.acpilight.enable     = true;
    environment.systemPackages    = [ pkgs.brightnessctl ];
    users.users.ender.extraGroups = lib.mkAfter [ "video" ];
  };
}
