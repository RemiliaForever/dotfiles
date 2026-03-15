{
  config,
  lib,
  host,
  ...
}:

let
  planet = ''
    AQAAAAAI6skKAAABbOPiOVXXRNSyCoV9iu9AGXeGj/KiYb6h8q1O1PTZCz+OWMkfTgVQAeZ7f7w+
    OUL9DMRztXzlH45fvIIIAubWmdi5PMPrbwTUnfw2yqE7CPnZ2zxkcur8JR1zPCEvKxCi1nTxj0bK
    UhSWAp42qi4EOMh9QFHaJ3H+q+s+RN2F815yVTpcDBoo9qJ+2ilFa/vCBRcpxEll00ukDpqtPYXp
    XAU5IEyUAWkBnwQOAHaDdVrcc9vN5rGCZcGYaSeHBPn3WUSvS78+VGU8VGp0p6PCPgOxHpNeQA6b
    jToIfX68efWMRoeZZPrDt1JPJUgAAQRqDvWXhkA=
  '';
  networkids = {
    koumakan = "69019f040e0e7783";
    game = "69019f040e3e2600";
  };
in
{
  options.services.zerotierone = {
    enableGame = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable joining the game network";
    };
  };

  config = {
    services.zerotierone = {
      enable = true;
      port = 29993;
      joinNetworks = [
        networkids.koumakan
      ]
      ++ (if config.services.zerotierone.enableGame then [ networkids.game ] else [ ]);
    };
    systemd.services.zerotierone.preStart = ''
      echo "${planet}" | base64 -d > /var/lib/zerotier-one/planet
    '';
    programs.zsh.shellAliases = {
      zerotier-peers = "sudo zerotier-cli peers";
      zerotier-refresh = ''
        sudo zerotier-cli leave ${networkids.koumakan} \
        && sudo zerotier-cli join ${networkids.koumakan} \
      ''
      + (
        if config.services.zerotierone.enableGame then
          ''
            && sudo zerotier-cli leave ${networkids.game} \
            && sudo zerotier-cli join ${networkids.game} \
          ''
        else
          ""
      )
      + ''
        && echo done
      '';
    };

    networking.hosts = {
      "127.0.0.1" = [ "koumakan-${host.hostname}" ];
      "172.18.10.1" = [ "ryzen" ];
      "172.18.10.2" = [ "console" ];
      "172.18.10.3" = [ "surface" ];
      "172.18.10.4" = [ "deck" ];
    };
  };
}
