{ pkgs, ... }:

{
  home.packages = [
    (pkgs.python313.withPackages (
      ppkgs: with ppkgs; [
        setuptools
        distutils
        ipython
      ]
    ))
  ];
}
