{ config, lib, ... }:

{
  options.my.home.btop = {
    enable = lib.mkEnableOption "btop system monitor";
  };

  config = lib.mkIf config.my.home.btop.enable {
    programs.btop = {
      enable   = true;
      settings = {
        vim_keys   = true;
        update_ms  = 1000;
        check_temp = true;
      };
    };
  };
}
