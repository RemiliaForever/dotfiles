{ ... }:

{
  programs = {
    zathura = {
      enable = true;
      options = {
        synctex = true;
        synctex-editor-command = "vim --remote-silent +%{line} %{input}";
        #highlight-transparency = 0.1;
      };
    };
  };
  xdg.mimeApps.defaultApplications."application/pdf" = [ "org.pwmt.zathura.desktop" ];
}
