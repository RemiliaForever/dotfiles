{ mypkgs, pkgs, ... }:

{

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
  ];

  home.packages = with pkgs; [
    dconf
    glxinfo
    kdePackages.qtsvg
    kdePackages.qtwayland
    libnotify
    vulkan-tools
    wayland-utils
    wl-clipboard-rs
    xdg-user-dirs

    networkmanagerapplet

    ark
    gwenview
    kdePackages.dolphin
    netease-cloud-music-gtk
    nextcloud-client
    #baidunetdisk
    wpsoffice-cn

    discord
    mypkgs.feishu
    mypkgs.wechat
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
