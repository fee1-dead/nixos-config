{ pkgs, config, ... }:
{
  imports = [
    ../media/niri.nix

  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "console=tty1" "nokaslr" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ ];
    extraModprobeConfig = "options nvidia_uvm uvm_disable_hmm=1";
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    cudaCapabilities = [ "10.0" "12.0" /* "12.1" */ ];
  };
  nixpkgs.overlays = [ (final: prev: { cudaPackages = prev.cudaPackages; }) ];

  programs.firefox.package = pkgs.firefox-bin;

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
      cudaSupport = true;
      # cudaPackages = cudaPackages_13;
    })
  ];

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    # open = true;
    nvidiaPersistenced = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.cloudflared = {
    enable = true;
    tunnels."dfa10061-f423-45e6-8229-c59e86167fd5" = {
      warp-routing.enabled = true;
      default = "http_status:404";
      credentialsFile = "/var/lib/cloudflared/dfa10061-f423-45e6-8229-c59e86167fd5.json";
    };
  };

  services.openssh.enable = true;
}
