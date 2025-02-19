{
  hostname,
  config,
  ...
}:

let
  direct_domain = [
    # common
    ".cn"
    # self
    "dmit.io"
    "koumakan.cc"
    # work
    "ipify.org"
    "fmsh.com"
    "deepseek.com"
    # game
    "steamcontent.com"
  ];
  direct_ip = [
    "154.17.13.197"
    "154.17.21.145"
  ];
  proxy_domain = [
    "dmhy.org"
  ];
  proxy_ip = [ ];

  planet = ''
    AQAAAAAI6skKAAABbOPiOVWEb/heo5RtscoWY0eIJLzOM+hK9nV61UCa5wIqpIOgTUiiDNRtzQqY
    Nh1TqZkJ6+JFj+7aSc91xSjux5rYmFeGFh/6GN2WUMCzfbZ5iZiBU5coYRE+jOceDJn9mAwW4Tgk
    6esCSS05TqbCLsK5nITSUDHh/E1OpEHtLoyKFDgXCXWMCszmIiMZrLIGpYqg3lIuurfphyJVCgKr
    +/4yDQ/eASC42WVLACml+LxB1QZZ4/kTAIVu2cN6Go0G2eLVXvCRNelw7Kgf2DeWUJZeF82j8NfW
    c57poxmn54yaL+RbqzmiyY0V8SMAAgSaEQ3FhkAGJgVSwAACAvk4n6D//o6Pw4ZA
  '';
  networkid = "20b8d9654b7800af";
in
{
  networking = {
    hostName = "koumakan-${hostname.hostname}";
    networkmanager.enable = true;
    firewall.enable = false;
    nftables.enable = true;
  };

  users.users.remilia.extraGroups = [ "networkmanager" ];

  # zerotier
  services.zerotierone = {
    enable = true;
    port = 29993;
    joinNetworks = [
      "${networkid}" # koumakan
    ];
  };
  systemd.services.zerotierone.preStart = ''
    echo "${planet}" | base64 -d > /var/lib/zerotier-one/planet
  '';
  programs.bash.shellAliases = {
    zerotier-peers = " sudo zerotier-cli peers";
    zerotier-refresh = " sudo zerotier-cli leave ${networkid} && sudo zerotier-cli join ${networkid}";
  };
  networking.hosts = {
    "172.18.10.1" = [
      "ryzen"
      "nextcloud.koumakan.cc"
      "gitlab.koumakan.cc"
    ];
    "172.18.10.2" = [ "console" ];
    "172.18.10.3" = [ "surface" ];
    "172.18.10.4" = [ "deck" ];
  };

  # sing-box
  services.sing-box = {
    enable = true;
    settings = {
      log.level = "warn";
      inbounds = [
        {
          type = "tun";
          tag = "tun-in";
          address = [
            "172.22.0.1/30"
            "fdfe:dcba:9876::1/126"
          ];
          auto_route = true;
          strict_route = true;
          sniff = true;
          sniff_timeout = "1s";
        }
      ];
      dns = {
        servers = [
          {
            tag = "dns-local";
            address = "114.114.114.114";
            strategy = "ipv4_only";
            detour = "direct-out";
          }
          {
            tag = "dns-proxy";
            address = "tcp://1.1.1.1";
            strategy = "ipv4_only";
            detour = "vless-out";
          }
        ];
        final = "dns-proxy";
        rules = [
          {
            outbound = "any";
            server = "dns-local";
          }
          {
            domain_suffix = proxy_domain;
            server = "dns-proxy";
          }
          {
            rule_set = "geosite-cn";
            domain_suffix = direct_domain;
            server = "dns-local";
          }
        ];
      };
      outbounds = [
        {
          type = "dns";
          tag = "dns-out";
        }
        {
          type = "direct";
          tag = "direct-out";
          tcp_fast_open = true;
        }
        {
          type = "vless";
          tag = "vless-out";
          server._secret = config.sops.secrets."singbox/server".path;
          server_port = 443;
          uuid._secret = config.sops.secrets."singbox/uuid".path;
          multiplex = {
            enabled = true;
            padding = false;
            protocol = "smux";
            max_streams = 64;
          };
          tls = {
            enabled = true;
            disable_sni = true;
            server_name._secret = config.sops.secrets."singbox/server_name".path;
          };
          transport = {
            type = "ws";
            path = "/notify";
          };
          tcp_fast_open = true;
        }
      ];
      route = {
        auto_detect_interface = true;
        geoip.path = "/dev/null";
        geosite.path = "/dev/null";
        rule_set = [
          {
            type = "remote";
            tag = "geosite-cn";
            format = "binary";
            url = "https://file.koumakan.cc/singbox/geosite-cn.srs";
            download_detour = "direct-out";
          }
          # {
          #   type = "remote";
          #   tag = "geosite-!cn";
          #   format = "binary";
          #   url = "https://file.koumakan.cc/singbox/geosite-geolocation-!cn.srs";
          #   download_detour = "direct-out";
          # }
          {
            type = "remote";
            tag = "geoip-cn";
            format = "binary";
            url = "https://file.koumakan.cc/singbox/geoip-cn.srs";
            download_detour = "direct-out";
          }
        ];
        final = "vless-out";
        rules = [
          {
            protocol = "dns";
            outbound = "dns-out";
          }
          {
            rule_set = [ ];
            domain_suffix = proxy_domain;
            ip_cidr = proxy_ip;
            outbound = "vless-out";
          }
          {
            ip_is_private = true;
            rule_set = [
              "geosite-cn"
              "geoip-cn"
            ];
            domain_suffix = direct_domain;
            ip_cidr = direct_ip;
            outbound = "direct-out";
          }
        ];
      };
    };
  };
}
