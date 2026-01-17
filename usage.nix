{ pkgs, inputs, ... }:
{
  imports = [
    ./base.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages/*_latest*/;
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
  environment.systemPackages = with pkgs; [
    prismlauncher
    pear-desktop
    qq
    (symlinkJoin {
      name = "vesktop";
      paths = [ vesktop ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vesktop --add-flags "--wayland-text-input-version=3"
      '';
    })
    zotero
    keymapp
    tinymist
    anki
    libwacom
    rnote
    obs-studio
    kdePackages.kdenlive
    rubberband
    mlt
    kdePackages.konversation
    kdePackages.filelight
    chromium
    zola
    kdePackages.plasma-vault
    mihomo
    racket
    distrobox
    thunderbird
    zoom-us
    coq
    coqPackages.stdlib
    coqPackages.mathcomp
    coqPackages.mathcomp-ssreflect
    coqPackages.vscoq-language-server
    elan
  ];
  environment.variables.ROCQ_PATH = "/run/current-system/sw/lib/coq/9.0/user-contrib/";
}