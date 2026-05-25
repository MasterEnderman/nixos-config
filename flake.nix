{
  description = "ender's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url    = "github:nix-community/home-manager";
    };

    stylix = {
      url    = "github:danth/stylix";
    };

    niri = {
      url                   = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url                   = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url                   = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url                   = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";

    chaotic = {
      url                   = "github:chaotic-cx/nyx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url                   = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-search-tv = {
      url                   = "github:3timeslazy/nix-search-tv";
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

    # Recursive module importer: only import regular files ending with .nix
		importModules = dir:
		  let
		    entries = builtins.readDir dir;
		    sorted = builtins.sort (a: b: lib.strings.compare a b) (builtins.attrNames entries);
		    recurse = path:
		      builtins.concatMap (entry:
		        let
		          fullPath = "\${path}/\${entry}";
		          t = builtins.readFileType fullPath;
		        in
		        if t == "directory" then recurse fullPath
		        else if t == "regular" && builtins.match ".\*\\\.nix\$" entry != null
		        then [ import fullPath ]
		        else []
		      ) (sorted);
		  in
		  recurse dir;
		
		hosts = builtins.attrNames (
		  lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts)
		);
		
		mkHost = hostname: lib.nixosSystem {
		  system = "x86\_64-linux";
		  specialArgs = { inherit zen-browser nix-search-tv; };
		  modules = [
		    ./hosts/\${hostname}
		    home-manager.nixosModules.homeManager
		    stylix.nixosModules.stylix
		    niri.nixosModules.niri
		    disko.nixosModules.disko
		    preservation.nixosModules.preservation
		    chaotic.nixosModules.default
		    sops-nix.nixosModules.sops
		    { nixpkgs.overlays = [ nur.overlays.default ]; }
		    ./users/ender.nix
		  ] ++ (importModules ./modules/nixos);
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