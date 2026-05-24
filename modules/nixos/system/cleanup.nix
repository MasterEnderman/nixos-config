{ config, lib, ... }:

{
  options.my.nixos.cleanup = {
    enable = lib.mkEnableOption "automatic nix store cleanup";

    keepGenerations = lib.mkOption {
      type    = lib.types.int;
      default = 5;
    };

    gcInterval = lib.mkOption {
      type    = lib.types.str;
      default = "weekly";
    };

    gcAge = lib.mkOption {
      type    = lib.types.str;
      default = "7d";
    };
  };

  config = lib.mkIf config.my.nixos.cleanup.enable {
    boot.loader.systemd-boot.configurationLimit =
      config.my.nixos.cleanup.keepGenerations;

    nix.gc = {
      automatic = true;
      dates     = config.my.nixos.cleanup.gcInterval;
      options   = "--delete-older-than ${config.my.nixos.cleanup.gcAge}";
    };

    nix.settings.auto-optimise-store = true;
  };
}
