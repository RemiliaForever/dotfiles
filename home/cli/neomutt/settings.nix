{ pkgs, ... }:

{
  home.packages = with pkgs; [ w3m ];
  programs.neomutt = {
    enable = true;

    unmailboxes = true;
    vimKeys = true;
    settings = {
      sort = "threads";
      sort_aux = "date";
      date_format = "'%Y-%m-%d,%a│%H:%M:%S'";
      index_format = "'%4C│%Z│%D│%-30.30L│%4c│%s'";
      status_format = "'[%f] %r [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?d? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?%?b? Inc:%b?%?l? %l?] (%s/%S) %> [%m](%P)'";
      folder_format = "'%2C %t %N %8s %d %f'";

      pager_index_lines = "6";
      pager_stop = "yes";

      # imap
      mbox_type = "Maildir";
      imap_check_subscribed = "yes";
      mail_check_stats = "yes";
      fast_reply = "yes";
      imap_keep_alive = "30";
      # smtp
      use_from = "yes";

      #sidebar
      sidebar_visible = "yes";
      sidebar_width = "30";
      sidebar_format = "'%B%?F? [%F]?%* %?N?%N/?%S'";
      sidebar_sort_method = "path";

      # mailcap
      mailcap_path = toString ./mailcap;
    };
    extraConfig = ''
      ignore *
      unignore date from to cc bcc subject
      unignore organization organisation x-mailer: x-newsreader: x-mailing-list:
      unignore posted-to:
      hdr_order Date: From: To: Cc: Bcc: Subject:
      auto_view text/html
      alternative_order text/plain text/enriched text/plain
    '';
  };
}
