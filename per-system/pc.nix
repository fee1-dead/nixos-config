{ pkgs, config, ... }:
{
  imports = [
    ../services/printing.nix
    ../services/networking.nix
    ../services/tor.nix
#    ../media/niri.nix
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


#  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];

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
    eww
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
}
