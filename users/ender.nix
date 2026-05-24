{ pkgs, import-tree, ... }:

{
  users.users.ender = {
    isNormalUser       = true;
    extraGroups        = [ "wheel" "networkmanager" "gamemode" ];
    shell              = pkgs.nushell;
    hashedPasswordFile = "/persist/passwords/ender";
  };

  home-manager = {
    useGlobalPkgs    = true;
    useUserPackages  = true;
    extraSpecialArgs = { inherit import-tree; };
    users.ender      = { import-tree, ... }: {
      imports = import-tree [ ./modules/home ];

      my.home = {
        # --- shell ---
        nushell.enable  = true;
        foot.enable     = true;
        starship.enable = true;

        # --- desktop ---
        noctalia.enable  = true;
        niri.enable      = true;
        hyprlock.enable  = true;
        stylix.enable    = true;
        fuzzel.enable    = true;
        grimblast.enable = true;
        imv.enable       = true;
        emote.enable     = true;

        # --- tui tools ---
        yazi.enable          = true;
        btop.enable          = true;
        pulsemixer.enable    = true;
        playerctl.enable     = true;
        lazygit.enable       = true;
        nix-search-tv.enable = true;

        # --- editors and development ---
        vscodium.enable  = true;
        jetbrains.enable = true;
        uv.enable        = true;

        # --- applications ---
        ghostwriter.enable    = true;
        onlyoffice.enable     = false;
        prism-launcher.enable = true;

        # --- git and ssh ---
        ssh.enable = true;
        git = {
          enable    = true;
          userName  = "Enderman";
          userEmail = "xxmr.endermanxx@gmail.com";
        };

        # --- workflow ---
        nix-workflow.enable = true;
      };

      home.stateVersion = "25.11";
    };
  };
}
