{ pkgs, ... }:
{
  imports = [
    ./base.nix
  ];
  boot = {
    # kernelPackages = pkgs.linuxPackages;
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  # gram extensions
  programs.nix-ld.enable = true;
  environment.systemPackages = with pkgs; [
    prismlauncher
    pear-desktop
    vesktop
    #zotero https://github.com/NixOS/nixpkgs/issues/568692
    keymapp
    tinymist
    nixfmt
    nil
    anki
    libwacom
    rnote
    obs-studio
    kdePackages.kdenlive
    rubberband
    mlt
    kdePackages.konversation
    kdePackages.filelight
    # chromium
    zola
    kdePackages.plasma-vault
    mihomo
    # racket
    distrobox
    openutau
    jetbrains.idea
    waywall
    nodejs
    ninjabrain-bot
    gram
    ruff
    vtsls
    superhtml
    tailwindcss-language-server
    eslint
    basedpyright
    coursier
    jdk
    jetbrains.clion

    /*
      coq
      coqPackages.stdlib
      coqPackages.mathcomp
      coqPackages.mathcomp-ssreflect
      coqPackages.vscoq-language-server
    */  elan
    idris2
    idris2Packages.idris2Lsp
    /*  ghc
    */
  ];
  environment.variables.ROCQ_PATH = "/run/current-system/sw/lib/coq/9.0/user-contrib/";
}
