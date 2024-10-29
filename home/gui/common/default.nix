{ pkgs, ... }:

{

  imports = [
    ./theme.nix
    ./wm_hyprland.nix
    ./wm_components.nix
    ./wm_waybar.nix
    ./wm_wofi.nix

    ./flameshot.nix
    ./wezterm.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    glxinfo
    vulkan-tools
    wayland-utils
    wl-clipboard-rs
    dconf
    kdePackages.qtsvg
    kdePackages.qtwayland
    libnotify

    ark
    gwenview
    kdePackages.dolphin
    mpv
    xdg-user-dirs
    networkmanagerapplet
    hyprpaper

    #baidunetdisk
    wpsoffice-cn
    #deluge
    discord
    feishu
    netease-cloud-music-gtk
    nextcloud-client
    #wechat-uos
    qq
  ];

  programs = {
    zathura = {
      enable = true;
      options = {
        synctex = true;
        synctex-editor-command = "vim --remote-silent +%{line} %{input}";
        #highlight-transparency = 0.1;
      };
    };
  };

  home.sessionVariables = {
    LANG = "zh_CN.UTF-8";
    LC_CTYPE = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
    LC_COLLATE = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_MESSAGES = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_ALL = "zh_CN.UTF-8";
  };
}
