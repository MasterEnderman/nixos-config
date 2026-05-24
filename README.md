# ender's NixOS Configuration — Usage Guide

This guide covers everything needed to go from a blank drive to a
fully working system. Follow steps in order.

---

## 1. Prepare the Installation USB

### Download the NixOS minimal ISO

```
https://nixos.org/download
```

Select the minimal ISO for x86_64-linux.

### Flash to USB

```bash
lsblk
sudo dd if=nixos-minimal-*.iso of=/dev/sdX \
  bs=4M status=progress conv=fsync
```

On Windows use Rufus. On macOS use Balena Etcher.

### Enable flakes on the live ISO

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" \
  >> ~/.config/nix/nix.conf
```

### Connect to WiFi if needed

```bash
sudo systemctl start wpa_supplicant
wpa_cli

add_network
set_network 0 ssid "your-wifi-name"
set_network 0 psk "your-wifi-password"
set_network 0 key_mgmt WPA-PSK
enable_network 0
quit
```

```bash
ping nixos.org
```

---

## 2. Add Hardware Configuration for a New Machine

Every host requires a `hardware-configuration.nix` committed to
the repository before installation. Skip this section if the
target host already has one committed.

### Generate

```bash
sudo nixos-generate-config \
  --no-filesystems \
  --root /mnt \
  --show-hardware-config > /tmp/hardware-configuration.nix
```

The `--no-filesystems` flag is required — without it the output
conflicts with Disko.

### Commit from any machine with the repo

```bash
cp /tmp/hardware-configuration.nix \
   hosts/<hostname>/hardware-configuration.nix
git add .
git commit -m "feat: add hardware config for <hostname>"
git push
```

---

## 3. Install

Replace `<hostname>` with the value of `networking.hostName`
in the host's `default.nix` — for example `hp-probook`.

### Partition and format

```bash
sudo nix run github:nix-community/disko -- \
  --mode disko \
  --flake github:ender/nixos-config#<hostname>
```

Disko prompts for your LUKS passphrase during this step.
This is the passphrase typed on every boot to decrypt the drive.
If you want one passphrase for everything, use the same string
you plan to use as your user password in the next step.

### Install NixOS

```bash
sudo nixos-install --flake github:ender/nixos-config#<hostname>
```

### Set user password before rebooting

```bash
sudo mkdir -p /mnt/persist/passwords
mkpasswd -m yescrypt | sudo tee /mnt/persist/passwords/ender
```

`mkpasswd` prompts for your password and writes only the hash.

### Reboot

```bash
sudo reboot
```

LUKS prompts for your passphrase. Once decrypted Niri starts
automatically and you land on the desktop.

---

## 4. First Boot

### Generate SSH keypair

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

Add `~/.ssh/id_ed25519.pub` to GitHub and any other services
that use SSH authentication.

### Wire up git commit signing

The `allowed_signers` file is generated automatically by
home-manager activation once the keypair exists. Run a rebuild
to trigger activation with the new key in place:

```bash
rebuild-local
```

From this point all git commits are signed automatically using
your SSH key.

---

## 5. Set Up Secrets (sops-nix)

One-time bootstrap per machine.

### Get the host age public key

```bash
nix-shell -p ssh-to-age --run \
  "ssh-to-age < /persist/etc/ssh/ssh_host_ed25519_key.pub"
```

### Add it to `.sops.yaml`

```yaml
keys:
  - &<hostname> age1<output-from-above>
```

Add the key to the `creation_rules` section so it can decrypt
the secrets file.

### Create or update the secrets file

First host:

```bash
nix-shell -p sops --run "sops secrets/secrets.yaml"
```

Additional hosts (re-encrypt for new key):

```bash
sops updatekeys secrets/secrets.yaml
```

### Commit and push

```bash
git add .sops.yaml secrets/secrets.yaml
git commit -m "feat: add sops key for <hostname>"
git push
```

### Adding a secret later

```bash
sops secrets/secrets.yaml
```

Reference it in `modules/nixos/system/sops.nix`:

```nix
sops.secrets."category/name" = {};
```

Available at runtime as `/run/secrets/category/name`.

---

## 6. Day-to-Day Workflows

### Rebuild after changes

Pull from GitHub and switch (auto-detects hostname):

```bash
rebuild
```

Local working directory (before pushing):

```bash
rebuild-local
```

### Commit workflow

Runs `nix flake check`, builds, formats with alejandra,
commits with generation number, pushes and switches:

```bash
nix-commit                        # gen 42: rebuild
nix-commit "add btop module"      # gen 42: add btop module
```

### Update flake inputs

Updates `flake.lock`, verifies build, commits and switches:

```bash
nix-update
```

### Roll back

Reverts system and repo to the previous generation:

```bash
nix-rollback
```

---

## 7. Maintenance

### Change user password

```bash
mkpasswd -m yescrypt | sudo tee /persist/passwords/ender
```

### Change LUKS passphrase

```bash
sudo cryptsetup luksChangeKey /dev/nvme0n1p2
```

### Manual garbage collection

```bash
nix-collect-garbage --delete-older-than 7d
```

Garbage collection also runs automatically every week.
The boot menu shows at most 5 generations.

---

## 8. Adding a New Host

1. Create `hosts/<hostname>/` with:
   - `default.nix` — hostname, boot config, enabled modules
   - `disko.nix` — disk layout
   - `hardware-configuration.nix` — generated as in section 2
   - `wallpaper.jpg` — drives the Stylix color scheme
2. Follow section 5 to add the host sops key
3. Follow section 3 to install

No changes to `flake.nix` needed — new host directories are
discovered automatically.

---

## Keybinds

### Navigation
| Keybind | Action |
|---|---|
| `Super+H/J/K/L` | Move focus |
| `Super+Arrow keys` | Move focus |
| `Super+Tab` | Next window |
| `Super+Q` | Close window |
| `Super+F` | Fullscreen |
| `Super+M` | Maximise |
| `Super+,/.` | Previous/next workspace |
| `Super+1-9` | Switch workspace |
| `Super+Escape` | Lock screen |

### System Keys
| Keybind | Action |
|---|---|
| `XF86AudioPlay/Next/Prev` | Media control |
| `XF86AudioRaise/LowerVolume` | Volume |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `XF86MonBrightnessUp/Down` | Brightness |
| `XF86RFKill` | Toggle airplane mode |

### Launch Applications
| Keybind | Action |
|---|---|
| `Super+Shift+Return` | Terminal |
| `Super+Shift+E` | File manager |
| `Super+Shift+Space` | App launcher |
| `Super+Shift+S` | Screenshot region |
| `Super+Shift+F` | Screenshot fullscreen |
| `Super+Shift+V` | Clipboard history |
| `Super+Shift+P` | Audio mixer |
| `Super+Shift+B` | System monitor |
| `Super+Shift+G` | Git client |
| `Super+Shift+.` | Emoji picker |
| `Super+Shift+?` | Nix search |

### Special
| Keybind | Action |
|---|---|
| `Super+Shift+Alt+S` | Save screenshot region |
| `Super+Shift+Alt+F` | Save screenshot fullscreen |
| `Super+Shift+Alt+Return` | Floating terminal |
| `Super+Shift+Alt+R` | Rebuild local |
| `Super+Shift+Alt+Q` | Quit niri |

### In Yazi
| Keybind | Action |
|---|---|
| `T` | Open terminal in current directory |
