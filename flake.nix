{
  description = "RemiliaForever's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-compact.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    #nur.url = "github:nix-community/nur";

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      sops-nix,
      home-manager,
      wezterm,
      ...
    }:

    let
      system = "${hostname.arch}";
      hostname = import ./hostname.nix;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations."koumakan-${hostname.hostname}" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit hostname;
          inherit pkgs;
          inherit nixos-hardware;
        };

        modules = [
          ./hosts/${hostname.hostname}
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.users.remilia = import ./hosts/${hostname.hostname}/home.nix;
            home-manager.extraSpecialArgs = {
              inherit pkgs;
              inherit wezterm;
            };
          }
        ];
      };
    };
}
