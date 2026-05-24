
{
  options.my.home.jetbrains = {
    enable = lib.mkEnableOption "intellij idea";
  };

  config = lib.mkIf config.my.home.jetbrains.enable {
    home.packages = with pkgs; [
      jetbrains.idea-community
      temurin-bin-8
      temurin-bin-17
      temurin-bin-21
      temurin-bin-25
    ];

    home.sessionVariables = {
      JAVA_HOME = "${pkgs.temurin-bin-21}";
    };
  };
}
