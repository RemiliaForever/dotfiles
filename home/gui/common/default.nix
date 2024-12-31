{ mypkgs, pkgs, ... }:

{
  xdg.mimeApps.enable = true;

  imports = [
    ./theme.nix
    ./wm_hyprland.nix
    ./wm_components.nix
    ./wm_swww.nix
    ./wm_mako.nix
    ./wm_waybar.nix
    ./wm_wofi.nix

    ./wezterm.nix
    ./firefox.nix
    ./mpv.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    dconf
    glxinfo
    kdePackages.qtsvg
    kdePackages.qtwayland
    libnotify
    networkmanagerapplet
    playerctl
    vulkan-tools
    wayland-utils
    wl-clipboard-rs
    xdg-user-dirs

    ark
    gwenview
    kdePackages.dolphin
    netease-cloud-music-gtk
    nextcloud-client
    #baidunetdisk
    wpsoffice-cn
    virt-manager

    discord
    mypkgs.feishu
    mypkgs.wechat
    qq
  ];

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
