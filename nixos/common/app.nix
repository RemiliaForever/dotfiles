{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nfs-utils
    cifs-utils

    dhex
    file
    htop
    iftop
    jq
    lm_sensors
    lsof
    ncdu
    nethogs
    p7zip
    pciutils
    pigz
    sysstat
    tree
    unrar
    wget

    nix-tree
    nix-index
  ];

  programs = {
    gnupg.agent = {
      enable = true;
    };
    git = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    screen = {
      enable = true;
      screenrc = ''
        startup_message off
        altscreen on
        backtick 1 5 5 true
        hardstatus string "screen (%n: %t)"
        caption string "%{= kG}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %{..Y} %m/%d %C%a "
        caption always
        termcapinfo xterm* ti@:te@
        term screen-256color
        scrollback 10000
      '';
    };
  };
}
