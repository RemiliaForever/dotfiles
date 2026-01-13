{
  pkgs,
  ...
}:

{

  home.packages = with pkgs; [
    # gnome-keyring
    gcr
    seahorse
  ];

  services.mako = {
    enable = true;

    settings = {
      default-timeout = 10000;
      layer = "overlay";
      sort = "-time";

      background-color = "#212121dd";
      border-radius = 8;
      border-size = 2;
      markup = 1;

      "urgency=low".border-color = "#595959ee";
      "urgency=normal".border-color = "#33ccffee";
      "urgency=high" = {
        border-color = "#f38ba8ee";
        default-timeout = 0;
      };

      on-notify = "exec ${pkgs.mpv}/bin/mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/bell.oga";
    };
  };

  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "/home/remilia/.background";
        sorting = "random";
        queue-size = 3;
        mode = "center";
        duration = "10min";
        transition-time = 1000;
      };
    };
  };

  # authentication
  services.polkit-gnome.enable = true;
  services.gnome-keyring.enable = true;
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      fade-in = 1;
      screenshots = true;
      clock = true;
      indicator = true;
      effect-blur = "20x5";
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
    config.common.default = "gnome";
  };

  # IME
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-chinese-addons
        fcitx5-material-color
      ];
      settings = {
        inputMethod = {
          "GroupOrder"."0" = "默认";
          "Groups/0" = {
            "Name" = "默认";
            "Default Layout" = "us";
            "DefaultIM" = "pinyin";
          };
          "Groups/0/Items/0"."Name" = "keyboard-us";
          "Groups/0/Items/1"."Name" = "pinyin";
          "Groups/0/Items/2"."Name" = "shuangpin";
        };
        globalOptions = {
          "Hotkey/TriggerKeys"."0" = "Control+space";
        };
        addons = {
          classicui.globalSection = {
            Font = "Sans 14";
            TrayFont = "Sans Bold 14";
            PreferTextIcon = "True";
            Theme = "Material-Color-blue";
          };
          cloudpinyin.globalSection = {
            MinimumPinyinLength = "2";
            Backend = "Google";
          };
          pinyin.globalSection = {
            ShuangpinProfile = "Xiaohe";
            PinyinInPreedit = "True";
            PageSize = "7";
            CloudPinyinEnabled = "True";
            CloudPinyinIndex = "3";
            CloudPinyinAnimation = "True";
            KeepCloudPinyinPlaceholder = "True";
          };
          xim.globalSection.UseOnTheSpot = "True";
        };
      };
    };
  };
  home.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "wayland;fcitx";
  };

}
