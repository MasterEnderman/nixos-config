{ config, lib, ... }:

{
  options.my.nixos.nushell = {
    enable = lib.mkEnableOption "nushell system config";
  };

  config = lib.mkIf config.my.nixos.nushell.enable {
    programs.bash.enable = true;
  };
}
