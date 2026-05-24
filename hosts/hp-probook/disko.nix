{ ... }:

{
  disko.devices = {
    disk.main = {
      type   = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {

          ESP = {
            size    = "512M";
            type    = "EF00";
            content = {
              type       = "filesystem";
              format     = "vfat";
              mountpoint = "/boot";
            };
          };

          luks = {
            size    = "100%";
            content = {
              type                   = "luks";
              name                   = "cryptroot";
              settings.allowDiscards = true;
              content = {
                type      = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {

                  "@nix" = {
                    mountpoint   = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };

                  "@persist" = {
                    mountpoint   = "/persist";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };

                  "@swap" = {
                    mountpoint         = "/.swapvol";
                    swap.swapfile.size = "8G";
                  };
                };
              };
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType       = "tmpfs";
      mountOptions = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };
  };
}
