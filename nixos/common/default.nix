{ ... }:

{
  imports = [
    ./app.nix
    ./boot.nix
    ./config.nix
    ./network
    ./nix.nix
    ./services.nix
    ./user.nix

    ./sops
  ];

  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "24.05";
}
