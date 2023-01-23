{ pkgs, ... }:
{
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.enableRimeData = true;
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-rime ];
}