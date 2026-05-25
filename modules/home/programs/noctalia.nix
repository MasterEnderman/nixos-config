{ config, lib, pkgs, ... }:

{
  options.my.home.noctalia = {
    enable = lib.mkEnableOption "noctalia desktop shell";
  };

  config = lib.mkIf config.my.home.noctalia.enable {
    home.packages = [ pkgs.noctalia-shell ];

    xdg.configFile."noctalia/config.json".text = builtins.toJSON {
      # placeholder — flesh out once you know what you want
    };
  };
}
