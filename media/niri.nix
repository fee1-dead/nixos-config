{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  xdg.portal.enable = true;
  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dex
    onagre
    xwayland-satellite

  # cc https://discourse.nixos.org/t/dolphin-does-not-have-mime-associations/48985/15
    (pkgs.writeTextFile {
    name = "minimal-applications-menu";
    text = ''
      <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
       "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

      <Menu>
        <Name>Applications</Name>

        <!-- Search the default directories for .desktop files.
             I.e. the /applications subdirectory of each entry in
             $XDG_DATA_DIRS
        -->
        <DefaultAppDirs/>

        <!-- Menus and submenus can use localized names as well as icons
             by referring to a .directory file. This configuration does
             not use them, but add it to the search for future-proofing.
        -->
        <DefaultDirectoryDirs/>

        <!-- Add every .desktop entry in the search result to this
             menu.
        -->
        <Include><All/></Include>

        <!-- List submenus before normal .desktop files in the menu. -->
        <DefaultLayout>
          <Merge type="menus"/>
          <Merge type="files" />
        </DefaultLayouts>

        <!-- Applications can add their own menu entries in
             menus/applications-merged/. This will cause them to
             be merged into this menu.
        -->
        <DefaultMergeDirs/>
      </Menu>
    '';
    destination = "/etc/xdg/menus/applications.menu";
    })
  ];
}
