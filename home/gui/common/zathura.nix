{ pkgs, ... }:

{
  programs = {
    zathura = {
      enable = true;
      options = {
        synctex = true;
        synctex-editor-command = "${pkgs.texlab}/bin/texlab inverse-search -i %{input} -l %{line}";
      };
    };
  };
  xdg.mimeApps.defaultApplications."application/pdf" = [ "org.pwmt.zathura.desktop" ];
}
