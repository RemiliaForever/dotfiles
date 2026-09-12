{ config, ... }:

{
  programs.zsh.shellAliases = {
    ssh = "TERM=xterm-256color ssh";
  };
  programs.kitty = {
    enable = true;
    settings = {
      font_family = ''family="Victor Mono" style=Light'';
      font_size = 11.5;
      scrollback_lines = 20000;
      modify_font = "cell_height -6px";

      hide_window_decorations = "yes";
      background_opacity = 0.9;

      background = "#181818";
      foreground = "#dcdfe4";

      # normal
      color0 = "#555555"; # "#282c34";
      color1 = "#e06c75";
      color2 = "#98c379";
      color3 = "#e5c07b";
      color4 = "#61afef";
      color5 = "#c678dd";
      color6 = "#56b6c2";
      color7 = "#dcdfe4";
      # bright
      color8 = "#555555"; # "#282c34";
      color9 = "#e06c75";
      color10 = "#98c379";
      color11 = "#e5c07b";
      color12 = "#61afef";
      color13 = "#c678dd";
      color14 = "#56b6c2";
      color15 = "#dcdfe4";

      copy_on_select = "clipboard";
      paste_actions = "no-op";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
      mouse_hide_wait = "-1.0";
      enable_audio_bell = "no";
    };
    # extraConfig = "modify_font baseline 4px";

    environment.PATH = builtins.concatStringsSep ":" [
      "/run/wrappers/bin"
      "${config.home.homeDirectory}/.nix-profile/bin"
      "/etc/profiles/per-user/${config.home.username}/bin"
      "/nix/var/nix/profiles/default/bin"
      "/run/current-system/sw/bin"
    ];

    keybindings = {
      "super+n" = "new_os_window_with_cwd";
      "ctrl+alt+d" = "remote_control scroll-window 0.5p";
      "ctrl+alt+u" = "remote_control scroll-window 0.5p-";
      "ctrl+alt+f" = "scroll_page_down";
      "ctrl+alt+b" = "scroll_page_up";
    };
  };
}
