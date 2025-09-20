{ config, ... }:

{
  accounts.email.accounts = {
    "koumakan" = {
      primary = true;

      address = "remilia@koumakan.cc";
      passwordCommand = "cat ${config.sops.secrets."mail/koumakan/password".path}";
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
    "nexa4ai" = {
      address = "hongzhichen@nexa4ai.com";
      passwordCommand = "cat ${config.sops.secrets."mail/nexa4ai/password".path}";
      userName = "hongzhichen@nexa4ai.com";
      realName = "Hongzhi Chen";

      imap = {
        tls.enable = true;
        host = "imap.gmail.com";
      };
      smtp = {
        tls.enable = true;
        host = "smtp.gmail.com";
      };

      folders = {
        drafts = "[Gmail]/Drafts";
        sent = "[Gmail]/Sent Mail";
        trash = "[Gmail]/Trash";
      };
      neomutt = {
        enable = true;
        mailboxType = "imap";
        showDefaultMailbox = false;
      };
    };
  };
}
