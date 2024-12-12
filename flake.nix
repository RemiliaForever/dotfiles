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
  };

  outputs =
    inputs@{
      self,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      sops-nix,
      wezterm,
      ...
    }:

    let
      system = "${hostname.arch}";
      hostname = import ./hostname.nix;
      pkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      mypkgs = import ./pkgs {
        inherit pkgs;
      };
    in
    {
      nixosConfigurations."koumakan-${hostname.hostname}" = nixpkgs-unstable.lib.nixosSystem {
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
              inherit wezterm;
              inherit mypkgs;
            };
          }
        ];
      };
    };
}
