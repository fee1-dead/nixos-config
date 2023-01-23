{ ... }:
{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}