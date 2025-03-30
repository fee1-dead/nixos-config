{ config, pkgs, nixpkgs, ... }:
{
  programs.eww = {
    enable = true;
    configDir = ./eww;
  };
}