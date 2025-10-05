{
  config,
  lib,
  host,
  ...
}:

let
  planet = ''
    AQAAAAAI6skKAAABbOPiOVWEb/heo5RtscoWY0eIJLzOM+hK9nV61UCa5wIqpIOgTUiiDNRtzQqY
    Nh1TqZkJ6+JFj+7aSc91xSjux5rYmFeGFh/6GN2WUMCzfbZ5iZiBU5coYRE+jOceDJn9mAwW4Tgk
    6esCSS05TqbCLsK5nITSUDHh/E1OpEHtLoyKFDgXCXWMCszmIiMZrLIGpYqg3lIuurfphyJVCgKr
    +/4yDQ/eASC42WVLACml+LxB1QZZ4/kTAIVu2cN6Go0G2eLVXvCRNelw7Kgf2DeWUJZeF82j8NfW
    c57poxmn54yaL+RbqzmiyY0V8SMAAgSaEQ3FhkAGJgVSwAACAvk4n6D//o6Pw4ZA
  '';
  networkids = {
    koumakan = "20b8d9654b7800af";
    nexa = "20b8d9654be491d9";
  };
in
{
  options.services.zerotierone.enableNexa = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable joining the nexa network";
  };

  config = {
    services.zerotierone = {
      enable = true;
      port = 29993;
      joinNetworks = [
        networkids.koumakan
      ]
      ++ (if config.services.zerotierone.enableNexa then [ networkids.nexa ] else [ ]);
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
        if config.services.zerotierone.enableNexa then
          ''
            && sudo zerotier-cli leave ${networkids.nexa} \
            && sudo zerotier-cli join ${networkids.nexa} \
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
      "172.18.10.5" = [ "win" ];
    }
    // (
      if config.services.zerotierone.enableNexa then
        {
          #"172.18.20.1" = [ "nexa-amd" ];
          "172.18.20.2" = [ "nexa-intel" ];
          "172.18.20.3" = [ "nexa-xelite" ];
          "172.18.20.4" = [ "nexa-amd" ];
          "172.18.20.5" = [ "nexa-lcfc" ];
          "172.18.20.6" = [ "nexa-xelite2" ];

          "44.251.240.140" = [ "nexa-mac" ];
        }
      else
        { }
    );
  };
}
