{
  description = "RemiliaForever's NixOS Flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      nixpkgs-unstable,
      home-manager,
      ...
    }:

    let
      fs = nixpkgs-unstable.lib.fileset;
      hostnames = fs.toList (fs.fileFilter (file: file.name == "hostname.nix") ./hosts);

      hosts = builtins.listToAttrs (
        builtins.map (hostname: {
          name = builtins.baseNameOf (builtins.dirOf hostname);
          value = import /${hostname};
        }) hostnames
      );
    in
    {
      nixosConfigurations = nixpkgs-unstable.lib.attrsets.mapAttrs' (_: host: {
        name = "koumakan-${host.hostname}";
        value = nixpkgs-unstable.lib.nixosSystem {
          system = "${host.arch}";

          specialArgs = {
            host = host;
            nixos-hardware = inputs.nixos-hardware;
            jovian = inputs.jovian;
            aagl = inputs.aagl;
            spicetify = inputs.spicetify;
          };

          modules = [
            inputs.grub2-themes.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            inputs.nix-index-database.nixosModules.nix-index
            ./hosts/${host.hostname}/os

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.remilia = import ./hosts/${host.hostname}/home;
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
            }

            ./overlays
          ];
        };

      }) hosts;
    };
}
