{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
    ../services/avahi.nix
    ../services/battery.nix
    ../services/computing.nix
#      ./services/docker.nix
    ../services/flatpak.nix
    ../services/networking.nix
    ../services/input.nix
    ../services/printing.nix
    ../services/scanning.nix
#      ./services/waydroid.nix
#      ./services/virt.nix
#      ./services/virtualbox.nix
#      ./services/redis.nix

      ../media/plex.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Bootloader.
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "owo"; # Define your hostname.

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # use latest linux.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    wineWowPackages.unstableFull
    wget
    gparted
    ripgrep
    mihomo # renamed from clash-meta
# idk
#     cloudflare-warp
    cloudflared
    typst-lsp
    zoom-us
    scrcpy
    kitty
    calibre
    ardour
    audacity
    tenacity
    # jetbrains.idea-community
  ];


  hardware.bluetooth.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.xserver.xkb = {
    variant = "colemak";
    layout = "us";
  };

  services.dae = {
    configFile = "/etc/nixos/services/config.dae";
    enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
