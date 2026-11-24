{ ... }:

{
  imports = [
    ./sops
  ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  home = {
    username = "remilia";
    homeDirectory = "/home/remilia";
  };

  home.file.".face".source = ./remilia.jpg;

  home.stateVersion = "26.05";
}
