{ config, lib, ... }:

{
  options.my.home.nushell = {
    enable = lib.mkEnableOption "nushell home config";
  };

  config = lib.mkIf config.my.home.nushell.enable {
    programs.nushell = {
      enable       = true;
      shellAliases = {
        # system rebuild
        rebuild       = "sudo nixos-rebuild switch --flake github:ender/nixos-config";
        rebuild-local = "sudo nixos-rebuild switch --flake .";

        # workflow
        nix-commit   = "~/.local/bin/nix-commit";
        nix-update   = "~/.local/bin/nix-update";
        nix-rollback = "~/.local/bin/nix-rollback";

        # general
        ll = "ls -l";
        la = "ls -la";
      };
      extraConfig = ''
        $env.config = {
          show_banner: false
          edit_mode:   vi
        }
        $env.PATH = ($env.PATH | prepend $"($env.HOME)/.local/bin")
      '';
    };
  };
}
