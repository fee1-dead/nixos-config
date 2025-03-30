{ pkgs, ... }:
{
  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    mako
    dex
    onagre
  ];
}
