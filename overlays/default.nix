{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'

  nixpkgs.overlays = [
    (final: prev: {
      lark = final.callPackage ./app/lark { };
      berkeley-mono = final.callPackage ./app/berkeley-mono { };
      kotlin-lsp = final.callPackage ./app/kotlin-lsp { }; # https://github.com/NixOS/nixpkgs/pull/482845
    })
    (import ./patch/pr.nix)
    (import ./patch/rollback.nix)
    (import ./patch/aagl.nix)
  ];
}
