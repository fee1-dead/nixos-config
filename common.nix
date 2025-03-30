# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:
{
  nix.settings = {
#    substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
    trusted-users = [ "root" "@wheel" ];
  };
  imports = [
    ./dev/common.nix
    ./dev/nix.nix
    ./media/sound.nix
    ./media/display.nix
    ./services/input.nix
    ./services/kdeconnect.nix
  ];

  nixpkgs.overlays = [ (final: prev: { 
    
  }) ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];


  time.timeZone = "Asia/Kuala_Lumpur";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  programs.nix-ld = {
    enable = true;
    libraries = [ pkgs.nss ];
  };

  programs.dconf.enable = true;

  programs.fish.enable = true;
  programs.fuse.userAllowOther = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.beef = {
    isNormalUser = true;
    description = "Deadbeef";
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
      "docker"
      "input"
      # for ROCm
      "video"
      "render"
    ];
    packages = with pkgs; [
      firefox
      kdePackages.kate
      kdePackages.skanlite
      samba
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    vlc
    kdePackages.ark
    libsForQt5.kclock
    gparted
    ripgrep
    prismlauncher
#    nss # required by minecraft
    wezterm
    gcc
    libreoffice-fresh
#   https://github.com/NixOS/nixpkgs/issues/368655
#   (sageWithDoc.override { requireSageTests = false; })
    youtube-music
#    qq
    vesktop
    jujutsu
    zotero_7
    fortune-kind
#    parsec-bin
    keymapp
#    zed-editor
    tinymist
    anki
    osu-lazer-bin
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.audiocd-kio
    activitywatch
    awatcher
    # (makeAutostartItem { name = "awatcher"; package = awatcher; })
  ];
  programs.nh = {
    enable = true;
    #clean.enable = true;
    #clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };
  hardware.opentabletdriver.enable = true;
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      iosevka
      ibm-plex
      noto-fonts
      noto-fonts-cjk-sans
      nerd-fonts.iosevka
      # (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
