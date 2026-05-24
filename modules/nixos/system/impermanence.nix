{ config, lib, ... }:

{
  options.my.nixos.impermanence = {
    enable = lib.mkEnableOption "tmpfs root with preservation";
  };

  config = lib.mkIf config.my.nixos.impermanence.enable {
    preservation = {
      enable                = true;
      persistentStoragePath = "/persist";

      users.ender = {
        directories = [
          # app state
          ".config"
          ".local/share"
          ".local/state"
          # personal directories
          "Downloads"
          "Projects"
          "Vault"
          # jetbrains config and gradle cache
          ".config/JetBrains"
          ".gradle"
        ];
        files = [
          ".ssh/id_ed25519"
          ".ssh/id_ed25519.pub"
        ];
      };

      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/machine-id"
      ];

      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/steam"
      ];
    };
  };
}
