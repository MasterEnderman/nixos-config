{ config, lib, pkgs, ... }:

{
  options.my.nixos.kernel = {
    enable = lib.mkEnableOption "cachyos performance kernel";

    variant = lib.mkOption {
      type    = lib.types.enum [
        "cachyos"
        "cachyos-bore"
        "cachyos-lto"
      ];
      default     = "cachyos";
      description = "cachyos kernel variant to use";
    };
  };

  config = lib.mkIf config.my.nixos.kernel.enable {
    boot.kernelPackages = pkgs.linuxPackages.${
      "linux_${config.my.nixos.kernel.variant}"
    };
  };
}
