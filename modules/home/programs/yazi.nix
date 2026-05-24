{ config, lib, ... }:

{
  options.my.home.yazi = {
    enable = lib.mkEnableOption "yazi file manager";
  };

  config = lib.mkIf config.my.home.yazi.enable {
    programs.yazi = {
      enable                   = true;
      enableNushellIntegration = true;
      settings = {
        manager = {
          layout         = [ 1 4 3 ];
          sort_by        = "natural";
          sort_dir_first = true;
          show_hidden    = false;
        };
        preview = {
          image_protocol = "kitty";
        };
      };
      keymap.manager.prepend_keymap = [
        {
          on   = [ "T" ];
          run  = ''shell 'foot --working-directory="$PWD"' --block false'';
          desc = "open terminal in current directory";
        }
      ];
    };
  };
}
