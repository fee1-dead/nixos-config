{ pkgs, ... }:
{
  networking.networkmanager.enable = true;
  # fix eduroam
  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
    openssl_conf = openssl_init
    [openssl_init]
    ssl_conf = ssl_sect
    [ssl_sect]
    system_default = system_default_sect
    [system_default_sect]
    Options = UnsafeLegacyRenegotiation
  '';
  # networking.firewall.allowedTCPPorts = [ 8010 8080 ];
  networking.firewall.enable = false;
  services.tor = {
    enable = true;
    client.enable = true;
    settings.MapAddress = "palladium.libera.chat libera75jm6of4wxpxt4aynol3xjmbtxgfyjpu34ss4d7r7q2v5zrpyd.onion";
  };
}
