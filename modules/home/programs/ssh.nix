{ config, lib, ... }:

{
  options.my.home.ssh = {
    enable = lib.mkEnableOption "ssh user configuration";
  };

  config = lib.mkIf config.my.home.ssh.enable {
    programs.ssh = {
      enable       = true;
      identityFile = [ "~/.ssh/id_ed25519" ];
      extraConfig  = ''
        AddKeysToAgent yes
      '';
    };
  };
}
