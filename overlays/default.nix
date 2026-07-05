{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'

  nixpkgs.overlays = [
    (final: prev: {
      berkeley-mono = final.callPackage ./app/berkeley-mono { };
      kotlin-lsp = final.callPackage ./app/kotlin-lsp { }; # https://github.com/NixOS/nixpkgs/pull/482845
    })
    (import ./patch/update.nix)
    (import ./patch/pr.nix)
    (import ./patch/aagl.nix)
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.34.0"
  ];
}
