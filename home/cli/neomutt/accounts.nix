{
  accounts.email.accounts = {
    "koumakan" = {
      primary = true;

      address = "remilia@koumakan.cc";
      passwordCommand = "cat /run/secrets/mail/koumakan/password";
      userName = "remilia@koumakan.cc";
      realName = "RemiliaForever";

      imap = {
        tls.enable = true;
        host = "imap.exmail.qq.com";
      };
      smtp = {
        tls.enable = true;
        host = "smtp.exmail.qq.com";
      };

      folders = {
        sent = "Inbox";
        trash = "Deleted Messages";
      };
      neomutt = {
        enable = true;
        mailboxType = "imap";
        showDefaultMailbox = false;
      };
    };
  };
}
