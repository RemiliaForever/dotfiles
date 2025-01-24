{
  description = "RemiliaForever's NixOS Flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      sops-nix,
      jovian,
      aagl,
      ...
    }:

    let
      system = "${hostname.arch}";
      hostname = import ./hostname.nix;
      mypkgs = import ./pkgs {
        pkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations."koumakan-${hostname.hostname}" = nixpkgs-unstable.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit hostname;
          inherit nixos-hardware;
          inherit aagl;
        };

        modules = [
          ./hosts/${hostname.hostname}/os
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.users.remilia = import ./hosts/${hostname.hostname}/home;
            home-manager.extraSpecialArgs = {
              inherit mypkgs;
            };
          }
          jovian.nixosModules.jovian
        ];
      };
    };
}
