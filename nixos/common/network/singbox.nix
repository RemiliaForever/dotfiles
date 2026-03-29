{ config, ... }:

let
  direct_domain = [
    # common
    ".cn"
    # self
    "dmit.io"
    "koumakan.cc"
    # ipinfo
    "ipify.org"
    "ip-api.com"
    "ipapi.co"
    "ipinfo.io"
    # work
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
  proxy_ip = [
    "::/0"
  ];
in
{
  services.sing-box = {
    enable = true;
    settings = {
      log.level = "warn";
      inbounds = [
        {
          tag = "tun-in";
          type = "tun";
          address = [
            "172.22.0.1/30"
            "fdfe:dcba:9876::1/126"
          ];
          auto_route = true;
          strict_route = true;
        }
      ];
      dns = {
        servers = [
          {
            tag = "dns-local";
            type = "udp";
            server = "114.114.114.114";
            # dialer
            detour = "direct-out";
          }
          {
            tag = "dns-proxy";
            type = "tls";
            server = "1.1.1.1";
            # dialer
            detour = "vless-out";
          }
          {
            tag = "dns-hosts";
            type = "hosts";
            predefined = {
              "singbox.koumakan.cc" = [
                "154.17.13.197"
                "154.17.21.145"
              ];
            };
          }
        ];
        rules = [
          {
            action = "route";
            rule_set = "geosite-cn";
            domain_suffix = direct_domain;
            server = "dns-local";
            strategy = "ipv4_only";
          }
          {
            action = "route";
            domain_suffix = proxy_domain;
            server = "dns-proxy";
            strategy = "prefer_ipv6";
          }
        ];
        final = "dns-proxy";
      };
      outbounds = [
        {
          tag = "direct-out";
          type = "direct";
          # dialer
          connect_timeout = "10s";
          tcp_fast_open = true;
        }
        {
          tag = "vless-out";
          type = "vless";
          server._secret = config.sops.secrets."singbox/server".path;
          server_port = 443;
          uuid._secret = config.sops.secrets."singbox/uuid".path;
          tls = {
            enabled = true;
            disable_sni = true;
          };
          transport = {
            type = "ws";
            path = "/notify";
            max_early_data = 2048;
          };
          # dialer
          connect_timeout = "10s";
          tcp_fast_open = true;
        }
      ];
      route = {
        rule_set = [
          {
            tag = "geosite-cn";
            type = "remote";
            format = "binary";
            url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-cn.srs";
            download_detour = "vless-out";
          }
          {
            tag = "geosite-steam-cn";
            type = "remote";
            format = "binary";
            url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-steam@cn.srs";
            download_detour = "vless-out";
          }
          {
            tag = "geoip-cn";
            type = "remote";
            format = "binary";
            url = "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs";
            download_detour = "vless-out";
          }
        ];
        rules = [
          { action = "sniff"; }
          {
            action = "hijack-dns";
            protocol = "dns";
          }
          {
            action = "route";
            rule_set = [ ];
            domain_suffix = proxy_domain;
            ip_cidr = proxy_ip;
            outbound = "vless-out";
          }
          {
            action = "route";
            ip_is_private = true;
            rule_set = [
              "geosite-cn"
              "geosite-steam-cn"
              "geoip-cn"
            ];
            domain_suffix = direct_domain;
            ip_cidr = direct_ip;
            outbound = "direct-out";
          }
        ];
        final = "vless-out";
        auto_detect_interface = true;
        default_domain_resolver = "dns-hosts";
      };
      experimental.clash_api = {
        external_controller = "127.0.0.1:9090";
        external_ui = "/var/lib/sing-box/ui";
        external_ui_download_url = "https://github.com/haishanh/yacd/archive/gh-pages.zip";
      };
    };
  };
}
