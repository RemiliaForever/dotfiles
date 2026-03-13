{
  programs.neomutt = {
    binds = [
      {
        map = [
          "index"
          "pager"
        ];
        key = "r";
        action = "noop";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "rr";
        action = "reply";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "rg";
        action = "group-reply";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "rc";
        action = "group-chat-reply";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\Cj";
        action = "sidebar-next";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\Ck";
        action = "sidebar-prev";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\Co";
        action = "sidebar-open";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\Cp";
        action = "sidebar-toggle-visible";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "@";
        action = "imap-fetch-mail";
      }
    ];
    macros = [
      {
        map = [ "attach" ];
        key = "B";
        action = "<pipe-message>cat > /tmp/mutt.html;xdg-open /tmp/mutt.html<enter>";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "<F2>";
        action = "<sync-mailbox><enter-command>source ~/.config/neomutt/koumakan<enter><change-folder>!<enter><check-stats>";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "<F3>";
        action = "<sync-mailbox><enter-command>source ~/.config/neomutt/nexa4ai<enter><change-folder>!<enter><check-stats>";
      }
    ];
  };
}
