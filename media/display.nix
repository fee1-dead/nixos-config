{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      variant = "colemak";
      layout = "us";
    };
    displayManager = {
      gdm.enable = true;
      defaultSession = "plasmawayland";
      # defaultSession = "hyprland";
    };
    # displayManager.sddm.enable = true;
#    desktopManager.gnome.enable = true;
     desktopManager.plasma5.enable = true;
  };
  # security.pam.services.gdm.enableGnomeKeyring = true;
  programs = {
    # hyprland.enable = true;
    # nm-applet.enable = true;
  };
  xdg.portal.extraPortals = [
    # pkgs.xdg-desktop-portal-hyprland
  ];
  /* environment.systemPackages = with pkgs; [
    dunst # notification daemon
    wofi # app launcher
    eww-wayland # status bar and widgets
    watershot # screenshot
    networkmanagerapplet
    gnome.seahorse
    hyprpaper
    grim
    slurp
  ]; */
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    # tali # poker game
    # iagno # go game
    # hitori # sudoku game
    # atomix # puzzle game
  ]);

}
