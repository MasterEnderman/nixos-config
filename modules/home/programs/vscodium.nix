{ config, lib, pkgs, ... }:

{
  options.my.home.vscodium = {
    enable = lib.mkEnableOption "vscodium editor";
  };

  config = lib.mkIf config.my.home.vscodium.enable {
    programs.vscode = {
      enable     = true;
      package    = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        # language support
        rust-lang.rust-analyzer
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        charliermarsh.ruff
        # quality of life
        usernamehw.errorlens
        esbenp.prettier-vscode
      ];
      userSettings = {
        "editor.fontFamily"                   = "monospace";
        "editor.fontSize"                     = 14;
        "editor.formatOnSave"                 = true;
        "editor.minimap.enabled"              = false;
        "workbench.startupEditor"             = "none";
        "explorer.confirmDelete"              = false;
        "window.menuBarVisibility"            = "toggle";
        "files.autoSave"                      = "onFocusChange";

        # nix
        "nix.formatterPath"                   = "alejandra";
        "nix.enableLanguageServer"            = true;
        "[nix]" = {
          "editor.defaultFormatter"           = "jnoortheen.nix-ide";
          "editor.formatOnSave"               = true;
        };

        # python
        "python.defaultInterpreterPath"       = "python";
        "python.terminal.activateEnvironment" = true;
        "python.venvPath"                     = "~/.venv";
        "[python]" = {
          "editor.defaultFormatter"           = "charliermarsh.ruff";
          "editor.formatOnSave"               = true;
        };
      };
    };
  };
}
