{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'

  nixpkgs.overlays = [
    (import ./hdpi.nix)
    (final: prev: {
      hyprshot = import ./hyprshot { pkgs = final; };
    })
    (import ./patch)
  ];
}
