{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    style.name = "breeze";
  };

  home.pointerCursor = {
    name = "capitaine-cursors-white";
    package = pkgs.capitaine-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
