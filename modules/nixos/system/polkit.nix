{ config, lib, pkgs, ... }:

{
  options.my.nixos.polkit = {
    enable = lib.mkEnableOption "polkit authentication agent";
  };

  config = lib.mkIf config.my.nixos.polkit.enable {
    security.polkit.enable = true;

    systemd.user.services.polkit-kde-agent = {
      description = "polkit kde authentication agent";
      wantedBy    = [ "graphical-session.target" ];
      wants       = [ "graphical-session.target" ];
      after       = [ "graphical-session.target" ];
      serviceConfig = {
        Type      = "simple";
        ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart   = "on-failure";
      };
    };
  };
}
