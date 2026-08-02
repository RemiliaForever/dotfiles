{ pkgs, ... }:

{
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };

  programs.system-config-printer.enable = true;

  environment.systemPackages = with pkgs; [ hplip ];
}
