{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'

  nixpkgs.overlays = [
    (final: prev: {
      lark = final.callPackage ./app/lark { };
      berkeley-mono = final.callPackage ./app/berkeley-mono { };
    })
    (import ./patch/pr.nix)
    (import ./patch/rollback.nix)
    (import ./patch/aagl.nix)
  ];
}
