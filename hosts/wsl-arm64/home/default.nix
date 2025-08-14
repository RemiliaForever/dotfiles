{ ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
  ];

  home.packages = [
  ];

  # cli
  programs.starship.settings.hostname.style = "red";

  home.sessionVariables = {
  };
}
