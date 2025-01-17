{ pkgs, ... }:

{
  services.mako = {
    enable = true;

    actions = true;
    backgroundColor = "#595959aa";
    borderColor = "#33ccffee";
    borderRadius = 8;
    borderSize = 2;
    defaultTimeout = 10000;

    icons = true;
    ignoreTimeout = false;
    layer = "overlay";
    sort = "-time";
  };
}
