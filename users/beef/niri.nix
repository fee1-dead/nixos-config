{ config, pkgs, nixpkgs, ... }:
{
  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink "/home/beef/develop/nixos-config/users/beef/niri";
}