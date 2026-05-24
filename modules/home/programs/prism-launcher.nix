{ config, lib, pkgs, ... }:

{
  options.my.home.prism-launcher = {
    enable = lib.mkEnableOption "prism launcher minecraft";
  };

  config = lib.mkIf config.my.home.prism-launcher.enable {
    home.packages = [ pkgs.prismlauncher ];
  };
}
