{ config, lib, ... }:

{
  options.my.home.foot = {
    enable = lib.mkEnableOption "foot terminal";
  };

  config = lib.mkIf config.my.home.foot.enable {
    programs.foot = {
      enable   = true;
      settings = {
        main  = {
          font = "monospace:size=11";
          pad  = "8x8";
        };
        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
