{ config, lib, ... }:

{
  options.my.nixos.sops = {
    enable = lib.mkEnableOption "sops-nix secrets management";
  };

  config = lib.mkIf config.my.nixos.sops.enable {
    sops = {
      age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
      age.keyFile     = "/var/lib/sops-nix/key.txt";
      age.generateKey = true;

      defaultSopsFile = ../../../secrets/secrets.yaml;

      # define secrets here as needed
      # each secret becomes available at /run/secrets/<name>
      secrets = {};
    };
  };
}
