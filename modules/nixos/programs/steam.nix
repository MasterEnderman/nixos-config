{ config, lib, pkgs, ... }:

{
  options.my.nixos.steam = {
    enable    = lib.mkEnableOption "steam with proton";
    gamescope = lib.mkOption {
      type    = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf config.my.nixos.steam.enable {
    programs.steam = {
      enable              = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = config.my.nixos.steam.gamescope;
    };

    programs.gamescope.enable = config.my.nixos.steam.gamescope;
    programs.gamemode.enable  = true;
  };
}
