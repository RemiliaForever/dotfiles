{ ... }:

{
  imports = [
    ./app.nix
    ./boot.nix
    ./config.nix
    #./gui.nix
    ./network.nix
    ./nix.nix
    ./services.nix
    ./user
    #./virtualisation.nix
  ];

  system.stateVersion = "24.05";
}
