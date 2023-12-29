{ ... }:
{
  networking.hostName = "uwu"; # Define your hostname.
  system.stateVersion = "24.05";
  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  systemd.services.nix-daemon.environment.all_proxy = "socks5h://192.168.1.7:7891";
}
