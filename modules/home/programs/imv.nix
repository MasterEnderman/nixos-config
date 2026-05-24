{ config, lib, ... }:

{
  options.my.home.imv = {
    enable = lib.mkEnableOption "imv image viewer";
  };

  config = lib.mkIf config.my.home.imv.enable {
    programs.imv = {
      enable   = true;
      settings = {
        options = {
          scaling_mode = "full";
          title_text   = "";
        };
      };
    };
  };
}
