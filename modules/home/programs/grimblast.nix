{ config, lib, pkgs, ... }:

{
  options.my.home.grimblast = {
    enable = lib.mkEnableOption "grimblast screenshot tool";
  };

  config = lib.mkIf config.my.home.grimblast.enable {
    home.packages = [ pkgs.grimblast ];
  };
}
