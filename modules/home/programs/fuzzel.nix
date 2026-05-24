{ config, lib, ... }:

{
  options.my.home.fuzzel = {
    enable = lib.mkEnableOption "fuzzel app launcher";
  };

  config = lib.mkIf config.my.home.fuzzel.enable {
    programs.fuzzel = {
      enable   = true;
      settings = {
        main = {
          lines    = 8;
          terminal = "foot";
        };
        border = {
          radius = 8;
          width  = 2;
        };
      };
    };
  };
}
