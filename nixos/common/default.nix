{ ... }:

{
  imports = [
    ./app.nix
    ./boot.nix
    ./config.nix
    ./network.nix
    ./nix.nix
    ./services.nix
    ./user.nix

    ./sops
  ];

  system.stateVersion = "24.05";
}
