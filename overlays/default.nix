{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'

  nixpkgs.overlays = [
    (final: prev: {
      hyprshot = import ./app/hyprshot { pkgs = final; };
      lark = final.callPackage ./app/lark { };
      drata-agent = final.callPackage ./app/drata { };
    })
    (import ./patch/pr.nix)
    (import ./patch/hdpi.nix)
  ];
}
