{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'

  nixpkgs.overlays = [
    (final: prev: {
      hyprshot = import ./hyprshot { pkgs = final; };
      lark = final.callPackage ./lark { };
    })
    (import ./hdpi.nix)
    (import ./patch)
  ];
}
