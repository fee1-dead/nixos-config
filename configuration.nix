# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:
let
  my-python-packages = ps: with ps; [
#    ipykernel
#    notebook
    # other python packages
  ];
in
{
#  nixpkgs.config.permittedInsecurePackages = [
#    "zotero-6.0.27"
#  ];
  nixpkgs.overlays = [
    (final: prev: {
#      typst-lsp = inputs.typst-lsp.packages.${pkgs.system}.default;
    })
  ];
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    '';
  };
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./dev/common.nix
    ./dev/nix.nix

    ./services/avahi.nix
    ./services/battery.nix
    ./services/computing.nix
#      ./services/docker.nix
    ./services/flatpak.nix
    ./services/networking.nix
    ./services/input.nix
    ./services/printing.nix
    ./services/scanning.nix
    ./services/kdeconnect.nix
#      ./services/waydroid.nix
#      ./services/virt.nix
#      ./services/virtualbox.nix
#      ./services/redis.nix

    ./media/display.nix
#      ./media/plex.nix
    ./media/sound.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # use latest linux kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  /*boot.kernelPatches = [{
    name = "Disable_per-vma_locking";
    patch = pkgs.fetchurl {
      url = "https://patchwork.kernel.org/project/linux-mm/patch/20230705063711.2670599-3-surenb@google.com/raw/";
      sha256 = "BPNxzFWrxf6wVpFeWdwtMJ24/+QYOgjAt3RYmm3D+hc=";
    };
    extraStructuredConfig = with lib.kernel; {
      # ARCH_SUPPORTS_PER_VMA_LOCK = no;
      # PER_VMA_LOCK = no;
    };
  }];*/

  networking.hostName = "nixos"; # Define your hostname.
  # Enable networking


  time.timeZone = "Asia/Kuala_Lumpur";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  programs.dconf.enable = true;
  # programs.ssh.startAgent = true;

  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.beef = {
    isNormalUser = true;
    description = "Deadbeef";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "docker" "input" ];
    packages = with pkgs; [
      firefox
      kate
      skanlite
      samba
    #  thunderbird
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wineWowPackages.unstableFull
    bottles
    wget
    vlc
    ark
    libsForQt5.kclock
#     blender
    gparted
    ripgrep
    libsForQt5.audiotube
    prismlauncher-qt5
    clash-meta
# idk
#     cloudflare-warp
    cloudflared
    typst-lsp
    zoom-us
    scrcpy
    wezterm
    kitty
    gcc
    calibre
    (python3.withPackages my-python-packages)
    sageWithDoc
  ];
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      iosevka
      noto-fonts
      noto-fonts-cjk-sans
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
  };


  hardware.bluetooth.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
