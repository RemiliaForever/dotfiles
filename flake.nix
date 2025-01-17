{
  description = "RemiliaForever's NixOS Flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-16facaed.url = "github:nixos/nixpkgs/16facaed1bda622e07aa534017bf0b6735071cd1";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    wezterm.url = "github:wez/wezterm?dir=nix";
    jovian = {
      url = "github:bigsaltyfishes/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      sops-nix,
      wezterm,
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
              inherit wezterm;
              inherit mypkgs;
            };
          }
          jovian.nixosModules.jovian
        ];
      };
    };
}
