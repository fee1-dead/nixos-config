{ pkgs, ... }:
{
  nix.package = pkgs.lix;
  nix.settings = {
    #    substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
  imports = [
    ./dev/common.nix
    ./dev/nix.nix
    ./media/sound.nix
    ./media/display.nix
    ./services/input.nix
    # ./services/dae.nix
    ./services/kdeconnect.nix
    ./services/networking.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {

    })
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
  };

  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  programs = {
    dconf.enable = true;
    fish.enable = true;
    fuse.userAllowOther = true;
    firefox.enable = true;
  };

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
    # libsForQt5.kclock
    gparted
    ripgrep
    prismlauncher
    #    nss # required by minecraft
    wezterm
    gcc
    libreoffice-fresh
    #   https://github.com/NixOS/nixpkgs/issues/368655
    #   (sageWithDoc.override { requireSageTests = false; })
    /*
      (symlinkJoin {
         name = "youtube-music";
         paths = [ youtube-music ];
         buildInputs = [ makeWrapper ];
         postBuild = ''
           wrapProgram $out/bin/youtube-music --add-flags "--wayland-text-input-version=3"
         '';
         })
    */
    youtube-music
    qq
    (symlinkJoin {
      name = "vesktop";
      paths = [ vesktop ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vesktop --add-flags "--wayland-text-input-version=3"
      '';
    })

    jujutsu
    zotero_7
    #    fortune-kind
    #    parsec-bin
    keymapp
    #    zed-editor
    tinymist
    anki
    #    osu-lazer-bin
    #    kdePackages.kio-fuse
    #    kdePackages.kio-extras
    #    kdePackages.audiocd-kio
    #    activitywatch
    #    awatcher
    # (makeAutostartItem { name = "awatcher"; package = awatcher; })
    libwacom
    rnote
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
      pkgs.buildFHSEnv (
        base
        // {
          name = "fhs";
          targetPkgs =
            pkgs:
            (base.targetPkgs pkgs)
            ++ (with pkgs; [
              pkg-config
            ]);
          profile = "export FHS=1";
          runScript = "fish";
          extraOutputsToInstall = [ "dev" ];
        }
      )
    )
    nixfmt-rfc-style
    nil
    obs-studio
    kdePackages.kdenlive
    rubberband
    mlt
    rustup
    git-absorb
    vlc
    kdePackages.konversation
    kdePackages.filelight
    chromium
    zola
    kdePackages.plasma-vault
    mihomo
    racket
    cloudflare-warp
    distrobox
  ];
  programs.nh = {
    enable = true;
    #clean.enable = true;
    #clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/beef/develop/nixos-config";
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
