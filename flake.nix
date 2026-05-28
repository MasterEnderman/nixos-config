{
  description = "ender's NixOS configuration";

	nixConfig = {
	    extra-substituters = [
	      "https://nix-community.cachix.org"
	    ];
	    extra-trusted-public-keys = [
	      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
	    ];
	};

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";

    chaotic = {
      url = "github:chaotic-cx/nyx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-search-tv = {
      url = "github:3timeslazy/nix-search-tv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    niri,
    zen-browser,
    nur,
    disko,
    preservation,
    chaotic,
    sops-nix,
    nix-search-tv,
    ...
  }:
  let
    lib = nixpkgs.lib;

    importModules = dir:
      map import (lib.filter (lib.hasSuffix ".nix") (lib.filesystem.listFilesRecursive dir));

    hosts = builtins.attrNames (
      lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts)
    );

    mkHost = hostname: lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit zen-browser nix-search-tv; };
      modules = [
        ./hosts/${hostname}
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        niri.nixosModules.niri
        disko.nixosModules.disko
        preservation.nixosModules.preservation
        chaotic.nixosModules.default
        sops-nix.nixosModules.sops
        { nixpkgs.overlays = [ nur.overlays.default ]; }
        ./users/ender.nix
        { home-manager.users.ender.imports = importModules ./modules/home; }
      ] ++ importModules ./modules/nixos;
    };
  in
  {
    nixosConfigurations = builtins.listToAttrs (
      map
        (hostname: { name = hostname; value = mkHost hostname; })
        hosts
    );
  };
}
