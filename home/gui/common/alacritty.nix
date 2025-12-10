{ ... }:

{
  # fix TERM
  programs.zsh.shellAliases.ssh = "TERM=xterm-256color ssh";

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };
      window = {
        decorations = "None";
        opacity = 0.9;
        dynamic_padding = true;
      };
      font = {
        size = 12;
        offset.x = -2;
        offset.y = -2;
        normal.style = "Light";
      };
      colors = {
        primary = {
          foreground = "0xdcdfe4";
        };
        normal = {
          black = "0x555555"; # "0x282c34";
          red = "0xe06c75";
          green = "0x98c379";
          yellow = "0xe5c07b";
          blue = "0x61afef";
          magenta = "0xc678dd";
          cyan = "0x56b6c2";
          white = "0xdcdfe4";
        };
        bright = {
          black = "0x555555"; # "0x282c34";
          red = "0xe06c75";
          green = "0x98c379";
          yellow = "0xe5c07b";
          blue = "0x61afef";
          magenta = "0xc678dd";
          cyan = "0x56b6c2";
          white = "0xdcdfe4";
        };
      };
      selection = {
        save_to_clipboard = true;
      };
      terminal.osc52 = "CopyPaste";
      mouse = {
        hide_when_typing = true;
      };
      keyboard.bindings = [
        {
          key = "N";
          mods = "Super";
          action = "CreateNewWindow";
        }
        {
          key = "D";
          mods = "Control|Alt";
          action = "ScrollPageDown";
        }
        {
          key = "U";
          mods = "Control|Alt";
          action = "ScrollPageUp";
        }
      ];
    };
  };
}
