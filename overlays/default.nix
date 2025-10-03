{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'

  nixpkgs.overlays = [
    (final: prev: {
      hyprshot = import ./app/hyprshot { pkgs = final; };
      lark = final.callPackage ./app/lark { };
      berkeley-mono = final.callPackage ./app/berkeley-mono { };
      github-copilot-cli = final.callPackage ./app/github-copilot-cli { };
    })
    (import ./patch/pr.nix)
    (import ./patch/hdpi.nix)
    (import ./patch/rollback.nix)
  ];
}
