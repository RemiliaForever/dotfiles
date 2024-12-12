{ pkgs, ... }:

{
  # inputMethod
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      plasma6Support = true;
      addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-chinese-addons
        fcitx5-material-color
      ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            "Name" = "默认";
            "Default Layout" = "us";
            "DefaultIM" = "pinyin";
          };
          "Groups/0/Items/0" = {
            "Name" = "keyboard-us";
          };
          "Groups/0/Items/1" = {
            "Name" = "pinyin";
          };
          "GroupOrder" = {
            "0" = "默认";
          };
        };
      };
    };
  };
}
