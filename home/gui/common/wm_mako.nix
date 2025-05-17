{ ... }:

{
  services.mako = {
    enable = true;

    settings = {
      actions = 1;
      default-timeout = 10000;
      ignore-timeout = 0;
      layer = "overlay";
      sort = "-time";

      icons = 1;
      background-color = "#595959aa";
      border-color = "#33ccffee";
      border-radius = 8;
      border-size = 2;
    };
  };
}
