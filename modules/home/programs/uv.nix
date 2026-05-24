{ config, lib, pkgs, ... }:

{
  options.my.home.uv = {
    enable = lib.mkEnableOption "uv python package manager";
  };

  config = lib.mkIf config.my.home.uv.enable {
    programs.uv = {
      enable   = true;
      settings = {
        python-preference = "only-system";
      };
    };

    home.packages = [ pkgs.python314 ];
  };
}
