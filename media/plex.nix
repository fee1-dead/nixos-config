{ lib, ... }:
{
  # enable plex
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # do not start on system boot
  systemd.services.plex.wantedBy = lib.mkForce [];
}