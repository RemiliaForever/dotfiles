{ ... }:

{
  imports = [
    ../../../home/user
    ../../../home/cli
    ../../../home/gui/common
  ];

  # cli
  programs.starship.settings.hostname.style = "blue";

  # wayland
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "eDP-1, preferred, auto, 1, transform, 3"
      ];
      device = [
        {
          name = "fts3528:00-2808:1015";
          transform = 3;
        }
      ];
    };
  };

  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = [
      "/sys/devices/pci0000:00/0000:00:08.1/0000:04:00.0/hwmon"
    ];
    input-filename = "temp1_input";
  };
}
