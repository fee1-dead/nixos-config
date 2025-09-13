{ pkgs, lib, ... }:
{
  services.phpfpm.pools.mediawiki.phpOptions = ''
    extension=${pkgs.phpExtensions.ldap}/lib/php/extensions/ldap.so
  '';
  services.mediawiki = {
    enable = true;
    httpd.virtualHost = {
      hostName = "localhost";
      adminAddr = "root@example.com";
    };
    passwordFile = pkgs.writeText "password" "hunter2wastaken";
    extensions = {
      PluggableAuth = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/PluggableAuth-REL1_44-cea83e0.tar.gz";
        hash = "sha256-1Gvz/r70dzqY54/IkKwFfros2UBolJgz83+HKEdTCMY=";
      };
      LDAPProvider = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/LDAPProvider-REL1_43-1764f85.tar.gz";
        hash = "sha256-84qxGUAsTcO+w1VXv01maKijEoIqLL31qBCZ/fDMK3o=";
      };
      LDAPAuthentication2 = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/LDAPAuthentication2-master-e1b0a0d.tar.gz";
        hash = "sha256-XVGgbu9Tv261we2dnC530vXMzdaRN57Md1FHpfq+e9E=";
      };
      LDAPUserInfo = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/LDAPUserInfo-master-ef464a1.tar.gz";
        hash = "sha256-jvmgG7KUq5kFkfRlN5aXiKo1t/5UibEED0Rj6Gu3olc=";
      };
    };
    extraConfig = ''
      $ldapJsonFile = "${../temp-ldap/ldap.json}";
      $LDAPProviderDomainConfigs = $ldapJsonFile;

      // Force LDAPGroups to sync by choosing a domain (e.g. first JSON object in ldap.json)
      $LDAPProviderDefaultDomain = array_key_first(json_decode(file_get_contents($LDAPProviderDomainConfigs), true));
      $wgPluggableAuth_Config = array(
        array(
          'plugin' => 'LDAPAuthentication2',
          'buttonLabelMessage' => 'pt-login-button',
          'data' => ['domain'=> $LDAPProviderDefaultDomain]
          )
      );
      $LDAPAuthentication2AllowLocalLogin = false;
      $wgDebugLogFile = "/var/log/mediawiki.log";
    '';
  };
}
