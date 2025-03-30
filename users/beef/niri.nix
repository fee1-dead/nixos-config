{ config, pkgs, nixpkgs, ... }:
{
  xdg.configFile."niri".source = "/etc/nixos/users/beef/niri";
}