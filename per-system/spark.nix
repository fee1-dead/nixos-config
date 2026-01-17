{ pkgs, config, ... }:
{
  imports = [
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
  };

  networking.hostName = "awa"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  system.stateVersion = "26.05";

  users.users.beef.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVaAo6Zjn6U50w0L8F31fA7aW8lAgek/gb7J39X8vX4 beef@uwu"
  ];

  /* swapDevices = [{
    device = "/swapfile";
  }]; */

  environment.systemPackages = with pkgs; [

#    bottles

    qemu
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
       qemu-system-x86_64 \
         -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
         "$@"
     '')
#    cloudflared
    sshfs
    (llama-cpp.override {
        rocmSupport = true;
        rocmGpuTargets = [ "gfx1100" ];
        vulkanSupport = true;
    })
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
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
#    rocmPackages.rocm-runtime
  ];
  services.xserver.videoDrivers = [ "modesetting" ];
  services.openssh.enable = true;
}
