{ pkgs, lib, config, ... }:
{
  imports = [
#    ../services/redis.nix
    ../services/printing.nix
    ../services/networking.nix
    ../media/niri.nix
  ];
#  nix.settings.trusted-substituters = ["https://ai.cachix.org"];
#  nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];

  networking.hostName = "uwu"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  /* networking = {
    interfaces.enp14s0 = {
      ipv4.addresses = [{
        address = "192.168.101.53";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.101.1";
      interface = "enp14s0";
    };
    defaultGateway6 = {
      address = "fe80::101";
      interface = "enp14s0";
    };
  }; */
  system.stateVersion = "24.05";

  users.users.beef.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbRYdNbAklKJBWZaCg3DWsOr/iSd8fVsMrMiZR+JNS4 beef@nixos"
  ];

  swapDevices = [{
    device = "/swapfile";
  }];

  # not _latest because of https://issues.chromium.org/issues/396434686
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelPatches = [
    /* {
      name = "rv";
      patch = ./reversed.patch;
    } */
  ];
#  boot.kernelPackages = pkgs.linuxPackages_6_4;
#  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
#  systemd.services.nix-daemon.environment.all_proxy = "socks5h://192.168.2.209:7891";
  environment.systemPackages = with pkgs; [
    blender-hip
    qq
    # rocmPackages.hipcc
    # rocmPackages.clr
    nodejs
    llama-cpp
    python3
    gnumake
#    bottles
#    wine
    distrobox
    tor-browser-bundle-bin
    qemu
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
       qemu-system-x86_64 \
         -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
         "$@"
     '')
#    cloudflared
    jetbrains.idea-community
    sshfs
#    kdePackages.audex
    eww
    mihomo
    clash-nyanpasu
    config.boot.kernelPackages.perf
  ];
  programs.corectrl.enable = true;
  hardware.keyboard.zsa.enable = true;


  /* systemd.tmpfiles.rules = let rocm-merged = pkgs.symlinkJoin {
    name = "rocm-merged";

    paths = with pkgs.rocmPackages; [
      rocm-core clr rccl miopen rocrand rocblas
      rocsparse hipsparse rocthrust rocprim hipcub roctracer
      rocfft rocsolver hipfft hipsolver hipblas
      rocminfo rocm-thunk rocm-comgr rocm-device-libs
      rocm-runtime clr.icd hipify
    ];

    # Fix `setuptools` not being found
    postBuild = ''
      rm -rf $out/nix-support
    '';
  }; in [
    "L+    /opt/rocm/   -    -    -     -    ${rocm-merged}"
  ]; */
  virtualisation.podman = {
    enable = true;
  };
  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
    rocmPackages.clr.icd
#    rocmPackages.rocm-runtime
  ];
  services.xserver.videoDrivers = [ "modesetting" ];
  services.openssh.enable = true;

  services.dae = {
    configFile = "/etc/nixos/services/config.dae";
    enable = true;
  };
  /* services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  }; */
  services.mediawiki = {
    enable = false;
    httpd.virtualHost = {
      hostName = "localhost";
      adminAddr = "root@example.com";
    };
    passwordFile = pkgs.writeText "password" "hunter2wastaken";
    extensions = {
      SecurePoll = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/SecurePoll-REL1_43-1d05ca6.tar.gz";
        hash = "sha256-oSa9enNvqJ6KiWrPyoxBNch7xYq3gxxxxf/byQm3lAw=";
      };
    };
    extraConfig = ''
      $wgGroupPermissions['electionadmin']['securepoll-create-poll'] = true;
      $wgGroupPermissions['electionadmin']['securepoll-edit-poll'] = true;
      $wgGroupPermissions['electionadmin']['securepoll-view-voter-pii'] = true;
    '';
  };
}
