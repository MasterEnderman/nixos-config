# base system configuration — enabled on every host
{ config, lib, pkgs, ... }:

{
  options.my.nixos.base = {
    enable = lib.mkEnableOption "base system configuration";
  };

  config = lib.mkIf config.my.nixos.base.enable {
    # networking
    networking.networkmanager.enable = true;

    # audio
    hardware.pulseaudio.enable = false;
    security.rtkit.enable      = true;
    services.pipewire = {
      enable             = true;
      alsa.enable        = true;
      alsa.support32Bit  = true;
      pulse.enable       = true;
      wireplumber.enable = true;
    };

    # nix settings
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # core tools
    programs.git.enable        = true;
    nixpkgs.config.allowUnfree = true;
  };
}
