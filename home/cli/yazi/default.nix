{ pkgs, config, ... }:

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
          desc = "Copy selected files to system clipboard";
        }
        {
          on = "p";
          run = "plugin smart-paste";
          desc = "Paste into the hovered directory or CWD";
        }
        {
          on = [ "R" ];
          run = "plugin recycle-bin";
          desc = "Open recycle bin";
        }
      ];
    };
    theme = { };
    initLua = ''
      require("full-border"):setup{
          type = ui.Border.ROUNDED,
      }
      require("ui"):setup()
      require("recycle-bin"):setup()
    '';
    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
      ui = ./ui.yazi;
      clipboard = pkgs.yaziPlugins.wl-clipboard;
      smart-paste = pkgs.yaziPlugins.smart-paste;
      recycle-bin = pkgs.yaziPlugins.recycle-bin;
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
