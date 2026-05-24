{ config, lib, pkgs, ... }:

{
  options.my.nixos.greetd = {
    enable = lib.mkEnableOption "greetd auto login";
  };

  config = lib.mkIf config.my.nixos.greetd.enable {
    services.greetd = {
      enable   = true;
      settings = {
        initial_session = {
          command = "niri";
          user    = "ender";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd niri";
          user    = "greeter";
        };
      };
    };
  };
}
