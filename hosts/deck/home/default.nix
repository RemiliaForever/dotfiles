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
  programs.niri.extraConfig = ''
    // Host Specific Configurations

    // Inputs

    input {

    }

    // Outputs

    output "eDP-1" {
        transform 90
    }
  '';
  programs.waybar = {
    temperature = {
      hwmon-path-abs = [
        "/sys/devices/pci0000:00/0000:00:08.1/0000:04:00.0/hwmon"
      ];
      input-filename = "temp1_input";
    };
  };
}
