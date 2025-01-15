{
  description = "RemiliaForever's NixOS Flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-compact.url = "github:nixos/nixpkgs/nixos-unstable";
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
