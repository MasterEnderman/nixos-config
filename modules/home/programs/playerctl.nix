{ config, lib, pkgs, ... }:

{
  options.my.home.playerctl = {
    enable = lib.mkEnableOption "playerctl media control";
  };

  config = lib.mkIf config.my.home.playerctl.enable {
    home.packages              = [ pkgs.playerctl ];
    services.playerctld.enable = true;
  };
}
