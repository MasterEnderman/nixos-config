{ config, lib, ... }:

{
  options.my.home.niri = {
    enable = lib.mkEnableOption "niri user config";
  };

  config = lib.mkIf config.my.home.niri.enable {
    programs.niri.settings = {

      window-rules = [
        # steam dialogs float automatically
        {
          matches              = [{ app-id = "steam"; is-floating = true; }];
          default-column-width = {};
          open-floating        = true;
        }
        # picture-in-picture always floats on top
        {
          matches       = [{ title = "Picture.in.Picture"; }];
          open-floating = true;
        }
      ];

      binds = {
        # --- navigation and window management ---
        "Mod+H".action.focus-column-left  = {};
        "Mod+J".action.focus-window-down  = {};
        "Mod+K".action.focus-window-up    = {};
        "Mod+L".action.focus-column-right = {};

        "Mod+Left".action.focus-column-left   = {};
        "Mod+Down".action.focus-window-down   = {};
        "Mod+Up".action.focus-window-up       = {};
        "Mod+Right".action.focus-column-right = {};

        "Mod+Tab".action.focus-window-down = {};
        "Mod+Q".action.close-window        = {};
        "Mod+F".action.fullscreen-window   = {};
        "Mod+M".action.maximize-column     = {};

        "Mod+Comma".action.focus-workspace-previous = {};
        "Mod+Period".action.focus-workspace-next    = {};

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Escape".action.spawn = [ "hyprlock" ];

        # --- system and media keys ---
        "XF86AudioPlay".action.spawn         = [ "playerctl" "play-pause" ];
        "XF86AudioNext".action.spawn         = [ "playerctl" "next" ];
        "XF86AudioPrev".action.spawn         = [ "playerctl" "previous" ];
        "XF86AudioRaiseVolume".action.spawn  = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+" ];
        "XF86AudioLowerVolume".action.spawn  = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
        "XF86AudioMute".action.spawn         = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        "XF86AudioMicMute".action.spawn      = [ "wpctl" "set-mute" "@DEFAULT_SOURCE@" "toggle" ];
        "XF86MonBrightnessUp".action.spawn   = [ "brightnessctl" "set" "+5%" ];
        "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "set" "5%-" ];
        "XF86RFKill".action.spawn            = [ "rfkill" "toggle" "all" ];

        # --- launch applications ---
        "Mod+Shift+Return".action.spawn = [ "foot" ];
        "Mod+Shift+E".action.spawn      = [ "foot" "--app-id" "yazi" "-e" "y" ];
        "Mod+Shift+Space".action.spawn  = [ "fuzzel" ];
        "Mod+Shift+S".action.spawn      = [ "grimblast" "copy" "area" ];
        "Mod+Shift+F".action.spawn      = [ "grimblast" "copy" "screen" ];
        "Mod+Shift+V".action.spawn      = [ "cliphist-fuzzel" ];
        "Mod+Shift+P".action.spawn      = [ "foot" "-e" "pulsemixer" ];
        "Mod+Shift+B".action.spawn      = [ "foot" "-e" "btop" ];
        "Mod+Shift+G".action.spawn      = [ "foot" "-e" "lazygit" ];
        "Mod+Shift+Period".action.spawn = [ "emote" ];
        "Mod+Shift+Slash".action.spawn  = [ "foot" "-e" "tv" "nix" ];

        # --- special launches ---
        "Mod+Shift+Alt+S".action.spawn      = [ "grimblast" "save" "area" ];
        "Mod+Shift+Alt+F".action.spawn      = [ "grimblast" "save" "screen" ];
        "Mod+Shift+Alt+Return".action.spawn = [ "foot" "--app-id" "floating" ];
        "Mod+Shift+Alt+R".action.spawn      = [ "foot" "-e" "rebuild-local" ];
        "Mod+Shift+Alt+Q".action.quit       = {};
      };
    };
  };
}
