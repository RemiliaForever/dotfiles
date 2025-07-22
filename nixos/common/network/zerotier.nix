{
  hostname,
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
  services.zerotierone = {
    enable = true;
    port = 29993;
    joinNetworks = [
      networkids.koumakan
      networkids.nexa
    ];
  };
  systemd.services.zerotierone.preStart = ''
    echo "${planet}" | base64 -d > /var/lib/zerotier-one/planet
  '';
  programs.zsh.shellAliases = {
    zerotier-peers = "sudo zerotier-cli peers";
    zerotier-refresh = ''
      sudo zerotier-cli leave ${networkids.koumakan} \
      && sudo zerotier-cli leave ${networkids.nexa} \
      && sudo zerotier-cli join ${networkids.koumakan} \
      && sudo zerotier-cli join ${networkids.nexa} \
      && echo done
    '';
  };

  networking.hosts = {
    "127.0.0.1" = [ "koumakan-${hostname.hostname}" ];
    "172.18.10.1" = [
      "ryzen"
      "nextcloud.koumakan.cc"
      "gitlab.koumakan.cc"
    ];
    "172.18.10.2" = [ "console" ];
    "172.18.10.3" = [ "surface" ];
    "172.18.10.4" = [ "deck" ];
    "172.18.10.5" = [ "win" ];

    "172.18.20.1" = [ "nexa-amd" ];
    "172.18.20.2" = [ "nexa-mac" ];
    "172.18.20.3" = [ "nexa-xelite" ];
  };
}
