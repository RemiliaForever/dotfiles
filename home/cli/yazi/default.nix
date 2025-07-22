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
    #[[ $- == *i* ]] && bind '"\C-o":"\C-u${config.programs.yazi.shellWrapperName}\C-m"'
    zle -N ${config.programs.yazi.shellWrapperName}
    bindkey '^O' ${config.programs.yazi.shellWrapperName}
  '';
}
