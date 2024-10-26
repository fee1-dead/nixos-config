{ pkgs, lib, config, ... }:
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-mozc fcitx5-hangul ];
  };
  environment.sessionVariables = {
    NIX_PROFILES =
      "${lib.concatStringsSep " " (lib.reverseList config.environment.profiles)}";
    XMODIFIERS = "@im=fcitx";
  };
}
