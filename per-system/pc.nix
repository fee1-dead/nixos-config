{ pkgs, ... }:
{
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
    blender-hip
    rocmPackages.hipcc
    rocmPackages.clr
    nodejs
    llama-cpp
    discord
    python3
    gnumake
    typst-preview
  ];
  hardware.opengl.driSupport = true;
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
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
