{ ... }:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 2;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;

        fontSize = 32;
        configurationLimit = 8;
      };
      grub2-theme = {
        enable = true;
        theme = "vimix";
        footer = true;
      };
    };

    kernelModules = [ "tcp_bbr" ];

    kernel.sysctl = {
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    tmp.useTmpfs = true;
  };

  zramSwap.enable = true;
}
