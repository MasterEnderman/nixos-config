{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "hp-probook";

  boot = {
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/persist".neededForBoot = true;

  stylix = {
    enable       = true;
    image        = ./wallpaper.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts        = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name    = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name    = "Noto Serif";
      };
      sizes = {
        terminal     = 11;
        applications = 12;
        desktop      = 12;
        popups       = 12;
      };
    };
  };

  my.nixos = {
    # --- base ---
    base.enable         = true;

    # --- programs ---
    nushell.enable      = true;
    niri.enable         = true;
    zen-browser.enable  = true;
    steam.enable        = true;

    # --- system ---
    greetd.enable       = true;
    impermanence.enable = true;
    sops.enable         = true;
    polkit.enable       = true;
    brightness.enable   = true;

    locale = {
      enable          = true;
      timezone        = "Europe/Berlin";
      locale          = "en_US.UTF-8";
      keyboardLayout  = "de";
      keyboardVariant = "";
    };

    cleanup = {
      enable          = true;
      keepGenerations = 5;
      gcInterval      = "weekly";
      gcAge           = "7d";
    };

    kernel = {
      enable  = true;
      variant = "cachyos";
    };
  };

  system.stateVersion = "25.11";
}
