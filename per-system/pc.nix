{ pkgs, config, ... }:
{
  imports = [
    ../services/printing.nix
    ../services/tor.nix
    ../media/niri.nix
  ];
  # nixpkgs.config.rocmSupport = true;

  networking.hostName = "uwu"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  /*services.zerotierone = {
    enable = true;
    joinNetworks = [
      "af78bf94362a9d18" 
    ];
  };*/
  services.tailscale.enable = true;
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

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "tsl-udev-rules";
      destination = "/etc/udev/rules.d/70-tsl.rules";
      text = ''
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0ca3", ATTRS{idProduct}=="0021", TAG+="uaccess"
      '';
    })
  ];

  /*services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ENV{ID_VENDOR_ID}=="0ca3", ENV{ID_MODEL_ID}=="0021", ENV{ID_USB_INTERFACE_NUM}=="02", MODE="0660", TAG+="uaccess"
  '';*/

  environment.systemPackages = with pkgs; [
    blender
    # rocmPackages.hipcc
    # rocmPackages.clr
    nodejs
    python3
    gnumake
#    bottles
    (wineWow64Packages.waylandFull.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./11355.patch
      ];
    }))
    winetricks
    tor-browser
    qemu
    lutris
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
       qemu-system-x86_64 \
         -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
         "$@"
     '')
#    cloudflared
    sshfs
    /*(llama-cpp.override {
        rocmSupport = true;
        rocmGpuTargets = [ "gfx1100" ];
        vulkanSupport = true;
    })*/

    perf
    sillytavern
    kdePackages.kdenlive
#    lmms
    # graalvmPackages.graalvm-ce
  ];
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
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
#    rocmPackages.rocm-runtime
  ];
  services.xserver.videoDrivers = [ "modesetting" ];
  services.openssh.enable = true;
}
