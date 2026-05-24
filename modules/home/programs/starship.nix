{ config, lib, ... }:

{
  options.my.home.starship = {
    enable = lib.mkEnableOption "starship prompt";
  };

  config = lib.mkIf config.my.home.starship.enable {
    programs.starship = {
      enable                   = true;
      enableNushellIntegration = true;
    };
  };
}
