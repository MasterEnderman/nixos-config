{ config, lib, ... }:

{
  options.my.home.stylix = {
    enable = lib.mkEnableOption "stylix home theming";
  };

  config = lib.mkIf config.my.home.stylix.enable {
    stylix.targets = {
      foot.enable     = true;
      nushell.enable  = true;
      starship.enable = true;
      niri.enable     = true;
      yazi.enable     = true;
      vscode.enable   = true;
      hyprlock.enable = true;
      btop.enable     = true;
      fuzzel.enable   = true;
    };
  };
}
