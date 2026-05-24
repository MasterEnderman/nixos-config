{ config, lib, ... }:

{
  options.my.nixos.locale = {
    enable = lib.mkEnableOption "locale and keyboard configuration";

    timezone = lib.mkOption {
      type    = lib.types.str;
      default = "Europe/Berlin";
    };

    locale = lib.mkOption {
      type    = lib.types.str;
      default = "en_US.UTF-8";
    };

    keyboardLayout = lib.mkOption {
      type    = lib.types.str;
      default = "de";
    };

    keyboardVariant = lib.mkOption {
      type    = lib.types.str;
      default = "";
    };
  };

  config = lib.mkIf config.my.nixos.locale.enable {
    time.timeZone = config.my.nixos.locale.timezone;

    i18n = {
      defaultLocale       = config.my.nixos.locale.locale;
      extraLocaleSettings = {
        LC_ADDRESS        = config.my.nixos.locale.locale;
        LC_IDENTIFICATION = config.my.nixos.locale.locale;
        LC_MEASUREMENT    = config.my.nixos.locale.locale;
        LC_MONETARY       = config.my.nixos.locale.locale;
        LC_NAME           = config.my.nixos.locale.locale;
        LC_NUMERIC        = config.my.nixos.locale.locale;
        LC_PAPER          = config.my.nixos.locale.locale;
        LC_TELEPHONE      = config.my.nixos.locale.locale;
        LC_TIME           = config.my.nixos.locale.locale;
      };
    };

    services.xserver.xkb = {
      layout  = config.my.nixos.locale.keyboardLayout;
      variant = config.my.nixos.locale.keyboardVariant;
    };

    console.keyMap = config.my.nixos.locale.keyboardLayout;
  };
}
