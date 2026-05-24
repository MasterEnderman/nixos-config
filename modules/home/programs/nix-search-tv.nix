{ config, lib, pkgs, nix-search-tv, ... }:

{
  options.my.home.nix-search-tv = {
    enable = lib.mkEnableOption "nix-search-tv tui search";
  };

  config = lib.mkIf config.my.home.nix-search-tv.enable {
    home.packages = [
      nix-search-tv.packages.${pkgs.system}.default
    ];
  };
}
