{ config, ... }:

{
  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        sort_by = "natural";
        linemode = "size";
        show_hidden = true;
      };
      preview = {
        max_width = 1920;
        max_height = 2160;
        cache_dir = "~/.cache/yazi";
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "<C-c>";
          run = "plugin clipboard";
        }
      ];
    };
    theme = {
      tabs = {
        sep_inner = {
          open = "";
          close = "";
        };
        sep_outer = {
          open = "";
          close = "";
        };
      };
    };
    initLua = ''
      require("ui"):setup()
    '';
    plugins = {
      clipboard = ./clipboard.yazi;
      ui = ./ui.yazi;
    };
  };

  programs.zsh.initContent = ''
    # yazi
    function yazi-cd() {
        ${config.programs.yazi.shellWrapperName}
        zle reset-prompt
    }
    zle -N yazi-cd
    bindkey '^O' yazi-cd
  '';
}
