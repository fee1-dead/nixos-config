{ config, pkgs, nixpkgs, ... }:
{
  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/users/beef/niri";
}