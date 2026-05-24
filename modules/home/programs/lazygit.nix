{ config, lib, ... }:

{
  options.my.home.lazygit = {
    enable = lib.mkEnableOption "lazygit tui git client";
  };

  config = lib.mkIf config.my.home.lazygit.enable {
    programs.lazygit = {
      enable   = true;
      settings = {
        os.shell          = "nu";
        os.shellArg       = "-c";
        confirmOnQuit     = false;
        git.log.showGraph = "always";
      };
    };
  };
}
