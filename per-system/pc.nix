{ pkgs, ... }:
{
  imports = [
    ../services/redis.nix
  ];
  nix.settings.trusted-substituters = ["https://ai.cachix.org"];
  nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];

  networking.hostName = "uwu"; # Define your hostname.
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
    # blender-hip
    # rocmPackages.hipcc
    # rocmPackages.clr
    nodejs
    llama-cpp
    python3
    gnumake
    tinymist
    bottles
    wine
    distrobox
    tor-browser-bundle-bin
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
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocmPackages.rocm-runtime
  ];
  services.xserver.videoDrivers = [ "modesetting" ];
  services.openssh.enable = true;
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
}
