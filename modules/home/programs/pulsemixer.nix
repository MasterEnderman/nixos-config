{ config, lib, pkgs, ... }:

{
  options.my.home.pulsemixer = {
    enable = lib.mkEnableOption "pulsemixer tui audio mixer";
  };

  config = lib.mkIf config.my.home.pulsemixer.enable {
    home.packages = [ pkgs.pulsemixer ];

    xdg.configFile."pulsemixer.cfg".text = ''
      [general]
      step     = 2
      step-big = 10

      [keys]
      mute       = m
      mute-input = M
    '';
  };
}
