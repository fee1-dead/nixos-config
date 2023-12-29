{ ... }:
{
  networking.hostName = "uwu"; # Define your hostname.
  system.stateVersion = "24.05";
  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
}
