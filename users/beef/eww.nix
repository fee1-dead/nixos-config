{ config, pkgs, nixpkgs, ... }:
{
  programs.eww = {
    enable = true;
    configDir = "/etc/nixos/users/beef/eww";
  };
}