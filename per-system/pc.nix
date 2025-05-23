{ pkgs, lib, ... }:
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
  system.stateVersion = "24.05";

  boot.kernelPackages = pkgs.linuxPackages_latest;
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
    cloudflared
    jetbrains.idea-community
    sshfs
#    kdePackages.audex
    eww
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
#    rocmPackages.rocm-runtime
  ];
  services.xserver.videoDrivers = [ "modesetting" ];
  services.openssh.enable = true;
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
