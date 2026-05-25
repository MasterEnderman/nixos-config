{ config, lib, pkgs, ... }:

{
  options.my.home.ghostwriter = {
    enable = lib.mkEnableOption "ghostwriter markdown editor";
  };

  config = lib.mkIf config.my.home.ghostwriter.enable {
    home.packages = [
      pkgs.kdePackages.ghostwriter
      pkgs.pandoc
    ];
  };
}
