{ pkgs, lib, ... }:

let
  dmsplugins = pkgs.fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dms-plugins";
    rev = "141841fc85e01494df6d217bd5a27c65da87256d";
    hash = "sha256-/155wFIotV9xiZzX9XRGs3ANjBcLJwS4kNDDNO6WkF0=";
  };
in
{
  imports = [
    ../services/fprint.nix
    ../services/bluetooth.nix
    ../media/niri.nix
    ../services/dae.nix
#    ../services/mediawiki.nix
  ];
  networking.hostName = "ovo"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.automatic-timezoned.enable = false;
  swapDevices = [{
    device = "/swap/swapfile";
    size = 16*1024;
  }];
  environment.systemPackages = with pkgs; [
    # wineWowPackages.waylandFull
    lutris
    haskell-language-server
    # wineWowPackages.full
  ];
  programs.gamescope.enable = true;
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "af78bf94362a9d18" 
    ];
  };
  programs.dms-shell.plugins = {
     KDEConnect.src = "${dmsplugins}/DankKDEConnect";
  };
  /*
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };*/


  # nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
