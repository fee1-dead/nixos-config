{ ... }:
{
  networking.networkmanager.enable = true;
#  services.connman.enable = true;
  # networking.firewall.allowedTCPPorts = [ 8010 8080 ];
  networking.firewall.enable = false;
  /* services.gvfs.enable = true;
  /* services.dae = {
    configFile = "/etc/nixos/services/config.dae";
    enable = true;
  }; */
}
