{ pkgs, config, lib, ... }:
{
  options.my.home.jetbrains = {
    enable = lib.mkEnableOption "intellij idea";
  };

  config = lib.mkIf config.my.home.jetbrains.enable {
    home.packages = with pkgs; [
      jetbrains.idea-oss
      temurin-bin-21  # Only the default JDK goes on PATH
    ];

    home.sessionVariables = {
      JAVA_HOME    = "${pkgs.temurin-bin-21}";
      JAVA_8_HOME  = "${pkgs.temurin-bin-8}";
      JAVA_17_HOME = "${pkgs.temurin-bin-17}";
      JAVA_21_HOME = "${pkgs.temurin-bin-21}";
      JAVA_25_HOME = "${pkgs.temurin-bin-25}";
    };
  };
}
