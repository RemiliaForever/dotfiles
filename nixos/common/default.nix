{ ... }:

{
  imports = [
    ./app.nix
    ./boot.nix
    ./config.nix
    ./network.nix
    ./nix.nix
    ./services.nix
    ./user
  ];

  system.stateVersion = "24.05";
}
