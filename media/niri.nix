{ pkgs, ... }:
{
  programs.niri.enable = true;
  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dex
    onagre
    xwayland-satellite
  ];
}
