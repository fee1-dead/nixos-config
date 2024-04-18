{ config, pkgs, nixpkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "beef";
  home.homeDirectory = "/home/beef";

  home.sessionVariables = {
    EDITOR = "nvim";
    MOZ_USE_XINPUT2 = "1";
  };
  systemd.user.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  home.packages = with pkgs; [
#    anki
#    iosevka
#    wget
#    rnix-lsp
#    jetbrains.idea-community
    obs-studio
    kdenlive
    rubberband
    mlt
    rustup
    git-absorb
    vlc
    # discord
    huggle
    layan-kde
    layan-gtk-theme
    libsForQt5.qtstyleplugin-kvantum
    konversation
    filelight
    chromium
#    texlive.combined.scheme-full
#    geogebra
#    zulip
#    premid
#    element-desktop
#    osu-lazer
#    qq
#    audacity
#    youtube-music
    lutris
    zola
    libsForQt5.plasma-vault
#    kmail
  ];

  home.shellAliases = {
    nswitch = "sudo bash -c 'nixos-rebuild switch |& nom'";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;/*
    extensions = with pkgs.vscode-extensions; [
#      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      ms-vscode-remote.remote-ssh
      zhuangtongfa.material-theme
      eamodio.gitlens
      usernamehw.errorlens
      vadimcn.vscode-lldb
      mkhl.direnv
      github.copilot
      ms-vscode.cpptools
      formulahendry.code-runner
      WakaTime.vscode-wakatime
      ms-vsliveshare.vsliveshare
      james-yu.latex-workshop
      mgt19937.typst-preview
    ];*/
    /*userSettings = {
      "_comment" = "This should only be edited at /etc/nixos/users/beef/home.nix.";
      "workbench.colorTheme" = "One Dark Pro Darker";
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'Iosevka'";
      "editor.fontSize" = 20;
      "files.autoSave" = "afterDelay";
      "editor.inlineSuggest.enabled" = true;
      "code-runner.runInTerminal" = true;
      "rust-analyzer.imports.granularity.enforce" = true;
      "rust-analyzer.imports.granularity.group" = "module";
      "editor.cursorSmoothCaretAnimation" = "on";
      "workbench.activityBar.visible" = false;
      "workbench.editor.showTabs" = false;
      "[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        "editor.rulers" = [100];
      };
      "editor.formatOnSave" = true;
      "window.zoomLevel" = 1;
    };*/
  };

  programs.git = {
    enable = true;
    userName = "Deadbeef";
    userEmail = "ent3rm4n@gmail.com";
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [vim-nix];
  };

  programs.fish = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
  };

 # services.swayidle = {
 #   enable = true;
 #   timeouts = [
 #     { timeout = 600; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
 #     {
 #       timeout = 610; command = "hyprctl dispatch dpms off";
 #       resumeCommand = "hyprctl dispatch dpms on";
 #     }
 #   ];
 # };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
