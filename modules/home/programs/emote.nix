{ config, lib, pkgs, ... }:

{
  options.my.home.emote = {
    enable = lib.mkEnableOption "emote emoji picker";
  };

  config = lib.mkIf config.my.home.emote.enable {
    home.packages = [ pkgs.emote ];
  };
}
