{
  pkgs,
  ...
}:

{
  # nix-build -E 'with import <nixpkgs> {}; callPackage ./example-package.nix {}'
  feishu = pkgs.callPackage ./feishu { };
  wechat = pkgs.callPackage ./wechat { };
  hyprshot = import ./hyprshot { inherit pkgs; };
}
