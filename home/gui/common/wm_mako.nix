{ ... }:

{
  services.mako = {
    enable = true;

    settings = {
      default-timeout = 10000;
      layer = "overlay";
      sort = "-time";

      background-color = "#212121dd";
      border-radius = 8;
      border-size = 2;

      "urgency=low".border-color = "#595959ee";
      "urgency=normal".border-color = "#33ccffee";
      "urgency=high" = {
        border-color = "#f38ba8ee";
        default-timeout = 0;
      };

      on-notify = "exec mpv /run/current-system/sw/share/sounds/freedesktop/stereo/bell.oga";
    };
  };
}
