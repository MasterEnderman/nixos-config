{ config, lib, ... }:

{
  options.my.home.ssh = {
    enable = lib.mkEnableOption "ssh user configuration";
  };

  config = lib.mkIf config.my.home.ssh.enable {
    programs.ssh = {
      enable       = true;
      extraConfig  = ''
        AddKeysToAgent yes
      '';
    };
  };
}
