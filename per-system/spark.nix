{ pkgs, config, ... }:
{
  imports = [
    ../media/niri.nix
   # ../services/dae.nix

  ];
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "console=tty1" "nokaslr" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ ];
    extraModprobeConfig = "options nvidia_uvm uvm_disable_hmm=1";
  };
  hardware.nvidia-container-toolkit.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    cudaCapabilities = [ "10.0" "12.0" "12.1" ];
  };
  nixpkgs.overlays = [ (final: prev: { cudaPackages = prev.cudaPackages_13; }) ];

  programs.firefox.package = pkgs.firefox-bin;

  networking.hostName = "awa"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  /*services.zerotierone = {
    enable = true;
    joinNetworks = [
      "af78bf94362a9d18"
    ];
  };*/
  system.stateVersion = "26.05";

  users.users.beef.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVaAo6Zjn6U50w0L8F31fA7aW8lAgek/gb7J39X8vX4 beef@uwu"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqUHzG7tYwM20JlmDZ/iIAaYKQ0t8UU6MI+8bG/H9Gq beef@ovo"
  ];
  /*users.users.yohello = {
    isNormalUser = true;
    description = "hi";
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
    packages = with pkgs; [];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7yTuvUpmp+uZO99x++eK2DUEdhk00l9Mj1AVGxSOwY mp2702737@gmail.com
" ];
  };*/

  /* swapDevices = [{
    device = "/swapfile";
  }]; */
  nixpkgs.config.permittedInsecurePackages = [
    # "python3.14-vllm-0.16.0"
  ];

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
    
   /*(llama-cpp.override {
      cudaSupport = true;
      cudaPackages = cudaPackages_13;
    })
    (koboldcpp.override {
      cudaPackages = cudaPackages_13;
      cudaArches = [ "sm_121" ];
      clblastSupport = true;
      vulkanSupport = true;
    })*/

    libaio
    espeak
    ffmpeg
    gcc
    gh
    mihomo
    python3
    gnumake
    waypipe
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
      pkgs.buildFHSEnv (
        base
        // {
          name = "fhs2";
          targetPkgs =
            pkgs:
            (base.targetPkgs pkgs)
            ++ (with pkgs; [
              pkg-config
              cudatoolkit
              cmake
            ]);
            profile = ''
              export FHS=1
              export CUDA_PATH=${pkgs.cudatoolkit}
              export LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH
              export EXTRA_LDFLAGS="-L/lib -L/run/opengl-driver/lib"
              export EXTRA_CCFLAGS="-I/usr/include"
          '';
          runScript = "fish";
          extraOutputsToInstall = [ "dev" ];
        }
      )
    )

    # (python314Packages.vllm.override { cudaPackages = cudaPackages_13; })
  ];

  # vscode ssh server
  programs.nix-ld.enable = true;

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

  /*services.cloudflared = {
    enable = true;
    tunnels."dfa10061-f423-45e6-8229-c59e86167fd5" = {
      warp-routing.enabled = true;
      default = "http_status:404";
      credentialsFile = "/var/lib/cloudflared/dfa10061-f423-45e6-8229-c59e86167fd5.json";
    };
  };*/

  services.openssh.enable = true;
  virtualisation.docker.enable = true;
}
