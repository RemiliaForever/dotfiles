{ pkgs, ... }:

let
  genMimeMap = (
    mimes:
    builtins.foldl' (
      acc: key:
      builtins.foldl' (
        innerAcc: v:
        innerAcc
        // {
          ${v} = key;
        }
      ) acc mimes.${key}
    ) { } (builtins.attrNames mimes)
  );
in
{

  imports = [
    ./theme.nix
    ./wm_hyprland.nix
    ./wm_components.nix
    ./wm_mako.nix
    ./wm_waybar.nix
    ./wm_wofi.nix
    ./wm_wpaperd.nix

    ./alacritty.nix
    ./firefox.nix
    ./mpv.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    # lib
    kdePackages.qtsvg
    # info
    #glxinfo
    #vulkan-tools
    #wayland-utils
    # tool
    brightnessctl
    kdePackages.kwallet
    libnotify
    playerctl
    ueberzugpp
    wl-clipboard-rs
    xdg-user-dirs
    # app
    kdePackages.ark
    kdePackages.gwenview
    netease-cloud-music-gtk
    nextcloud-client
    virt-manager
    wpsoffice-cn
  ];

  xdg = {
    desktopEntries = {
      "yazi-alacritty" = {
        name = "Yazi (Alacritty)";
        icon = "yazi";
        comment = "Blazing fast terminal file manager written in Rust, based on async I/O";
        exec = "alacritty -e yazi";
        type = "Application";
        mimeType = [ "inode/directory" ];
        categories = [
          "Utility"
          "Core"
          "System"
          "FileTools"
          "FileManager"
        ];
      };
      "neovim-alacritty" = {
        name = "Neovim (Alacritty)";
        icon = "nvim";
        comment = "Edit text files";
        exec = "alacritty -e nvim %F";
        type = "Application";
        mimeType = [
          "text/english"
          "text/plain"
          "text/markdown"
          "application/json"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
        categories = [
          "Utility"
          "TextEditor"
        ];
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = genMimeMap {
        "yazi-alacritty.desktop" = [ "inode/directory" ];
        "neovim-alacritty.desktop" = [
          "text/english"
          "text/plain"
          "text/markdown"
          "application/json"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
        "firefox.desktop" = [
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
        "org.pwmt.zathura.desktop" = [ "application/pdf" ];
        "org.kde.gwenview.desktop" = [
          "image/avif"
          "image/gif"
          "image/heif"
          "image/jpeg"
          "image/jxl"
          "image/png"
          "image/bmp"
          "image/x-eps"
          "image/x-icns"
          "image/x-ico"
          "image/x-portable-bitmap"
          "image/x-portable-graymap"
          "image/x-portable-pixmap"
          "image/x-xbitmap"
          "image/x-xpixmap"
          "image/tiff"
          "image/x-psd"
          "image/x-webp"
          "image/webp"
          "image/x-tga"
          "image/x-xcf"
          "image/x-kde-raw"
          "image/x-canon-cr2"
          "image/x-canon-crw"
          "image/x-kodak-dcr"
          "image/x-adobe-dng"
          "image/x-kodak -k25"
          "image/x-kodak-kdc"
          "image/x-minolta-mrw"
          "image/x-nikon-nef"
          "image/x-olympus-orf"
          "image/x-pentax-pef"
          "image/x-fuji-raf"
          "image/x-panasonic-rw"
          "image/x-sony-sr2"
          "image/x-sony-srf"
          "image/x-sigma-x3f"
          "image/x-sony-arw"
          "image/x-panasonic-rw2"
        ];
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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    publicShare = null;
    templates = null;
  };
}
