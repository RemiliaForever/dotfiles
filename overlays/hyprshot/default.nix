{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "Hyprshot";
  runtimeInputs = with pkgs; [
    hyprland
    jq
    grim
    slurp
    wl-clipboard-rs
    libnotify
    hyprpicker
  ];
  text = builtins.readFile ./hyprshot.sh;
}
