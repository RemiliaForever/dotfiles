{
  description = "RemiliaForever's NixOS Flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    grub2-themes.url = "github:vinceliuice/grub2-themes";
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
      grub2-themes,
      home-manager,
      sops-nix,
      jovian,
      aagl,
      ...
    }:

    let
      system = "${hostname.arch}";
      hostname = import ./hostname.nix;
    in
    {
      nixosConfigurations."koumakan-${hostname.hostname}" = nixpkgs-unstable.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit hostname;
          inherit nixos-hardware;
          inherit jovian;
          inherit aagl;
        };

        modules = [
          grub2-themes.nixosModules.default
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          ./hosts/${hostname.hostname}/os
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.users.remilia = import ./hosts/${hostname.hostname}/home;
          }
          ./overlays
        ];
      };
    };
}
