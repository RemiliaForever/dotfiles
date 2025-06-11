{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'

  nixpkgs.overlays = [
    (final: prev: {
      hyprshot = import ./hyprshot { pkgs = final; };
      lark = final.callPackage ./lark { };
      drata-agent = final.callPackage ./drata { };
    })
    (import ./hdpi.nix)
    (import ./patch)
  ];
}
