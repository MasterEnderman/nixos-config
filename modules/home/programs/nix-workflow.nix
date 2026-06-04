{ config, lib, pkgs, ... }:

{
  options.my.home.nix-workflow = {
    enable = lib.mkEnableOption "nix workflow automation scripts";
  };

  config = lib.mkIf config.my.home.nix-workflow.enable {
    home.packages = [
      pkgs.alejandra
      pkgs.nix-output-monitor
    ];

    home.file.".local/bin/nix-commit" = {
      executable = true;
      text = ''
        #!/usr/bin/env nu

        def main [comment?: string] {
          # check flake
          print "checking flake..."
          let check = (do { nix flake check } | complete)
          if $check.exit_code != 0 {
            print "flake check failed — aborting"
            print $check.stderr
            exit 1
          }

          # build without activating
          print "building system..."
          let build = (do { sudo nixos-rebuild build --flake . } | complete)
          if $build.exit_code != 0 {
            print "build failed — aborting"
            print $build.stderr
            exit 1
          }

          # format
          alejandra .

          # stage
          git add -A

          # commit message from generation number
          let gen = (
            nixos-rebuild list-generations
            | lines | last | str trim | split row " " | first
          )
          let msg = if ($comment | is-empty) {
            $"gen ($gen): rebuild"
          } else {
            $"gen ($gen): ($comment)"
          }

          # commit and push
          git commit -m $msg
          git push
          print $"pushed: ($msg)"

          # switch
          print "switching system..."
          let switch = (do {
            sudo nixos-rebuild switch --flake github:masterenderman/nixos-config
          } | complete)
          if $switch.exit_code != 0 {
            print "switch failed — run 'rebuild' manually to retry"
            print $switch.stderr
            exit 1
          }
          print "done — system in sync"
        }
      '';
    };

    home.file.".local/bin/nix-update" = {
      executable = true;
      text = ''
        #!/usr/bin/env nu

        def main [] {
          # update inputs
          print "updating flake inputs..."
          nix flake update

          # check
          print "checking flake..."
          let check = (do { nix flake check } | complete)
          if $check.exit_code != 0 {
            print "flake check failed — flake.lock NOT committed"
            print $check.stderr
            exit 1
          }

          # build
          print "building system..."
          let build = (do { sudo nixos-rebuild build --flake . } | complete)
          if $build.exit_code != 0 {
            print "build failed — flake.lock NOT committed"
            print $build.stderr
            exit 1
          }

          # commit and push lockfile only
          git add flake.lock
          let date = (date now | format date "%Y-%m-%d")
          git commit -m $"chore: update flake.lock ($date)"
          git push
          print "pushed flake.lock"

          # switch
          print "switching system..."
          let switch = (do {
            sudo nixos-rebuild switch --flake github:masterenderman/nixos-config
          } | complete)
          if $switch.exit_code != 0 {
            print "switch failed — run 'rebuild' manually to retry"
            print $switch.stderr
            exit 1
          }
          print "done — system in sync"
        }
      '';
    };

    home.file.".local/bin/nix-rollback" = {
      executable = true;
      text = ''
        #!/usr/bin/env nu

        def main [] {
          print "warning: rolls back system config only — /persist is unaffected"
          print ""
          nixos-rebuild list-generations
          print ""

          let confirm = (input "roll back to previous generation? (y/n): ")
          if $confirm != "y" {
            print "cancelled"
            exit 0
          }

          # rollback system
          let rollback = (do { sudo nixos-rebuild switch --rollback } | complete)
          if $rollback.exit_code != 0 {
            print "rollback failed"
            print $rollback.stderr
            exit 1
          }
          print "system rolled back"

          # revert last commit
          let revert = (do { git revert HEAD --no-edit } | complete)
          if $revert.exit_code != 0 {
            print "git revert failed — run 'git revert HEAD --no-edit' manually"
            print $revert.stderr
            exit 1
          }

          # push
          let push = (do { git push } | complete)
          if $push.exit_code != 0 {
            print "push failed — run 'git push' manually"
            print $push.stderr
            exit 1
          }

          print ""
          print "rollback complete — system and repo in sync"
          nixos-rebuild list-generations
        }
      '';
    };
  };
}
