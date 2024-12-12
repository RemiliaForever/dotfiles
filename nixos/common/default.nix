{ ... }:

{
  imports = [
    ./app.nix
    ./boot.nix
    ./config.nix
    ./network.nix
    ./nix.nix
    ./nix_gc_env.nix
    ./services.nix
    ./user
  ];

  system.stateVersion = "24.05";
}
