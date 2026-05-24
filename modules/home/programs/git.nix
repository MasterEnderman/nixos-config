{ config, lib, ... }:

{
  options.my.home.git = {
    enable = lib.mkEnableOption "git user configuration";

    userName = lib.mkOption {
      type        = lib.types.str;
      description = "git commit author name";
    };

    userEmail = lib.mkOption {
      type        = lib.types.str;
      description = "git commit author email";
    };
  };

  config = lib.mkIf config.my.home.git.enable {
    programs.git = {
      enable    = true;
      userName  = config.my.home.git.userName;
      userEmail = config.my.home.git.userEmail;

      # ssh commit signing — reuses the key declared in ssh.nix [11]
      signing = {
        key           = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch               = "main";
        pull.rebase                      = true;
        push.autoSetupRemote             = true;
        gpg.format                       = "ssh";
        "gpg \"ssh\"".allowedSignersFile =
          "${config.home.homeDirectory}/.config/git/allowed_signers";
      };
    };

    # generate allowed_signers at activation by reading the public key
    # from programs.ssh — no key content stored in the config [11][13]
    home.activation.generateAllowedSigners =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $HOME/.config/git
        if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
          echo "${config.my.home.git.userEmail} $(cat $HOME/.ssh/id_ed25519.pub)" \
            > $HOME/.config/git/allowed_signers
        fi
      '';
  };
}
