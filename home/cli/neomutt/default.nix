{ pkgs, ... }:

{
  programs.neomutt.enable = true;

  home.file = {
    ".config/neomutt/deepglint".source = ./deepglint;
    ".config/neomutt/koumakan".source = ./koumakan;
    #".config/neomutt/aliases".source = ./aliases;
    ".config/neomutt/bindings".source = ./bindings;
    ".config/neomutt/colors".source = ./colors;
    ".config/neomutt/mailcap".source = ./mailcap;
    ".config/neomutt/muttrc".source = ./deepglint/muttrc;
    ".config/neomutt/muttrc.common".source = ./muttrc.common;
  };
}
