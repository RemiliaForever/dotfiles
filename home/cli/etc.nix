{ ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host dmit
          HostName koumakan.cc
          Port 121
          User root
    '';
  };
  home.file = {
    ".latexmkrc".text = ''
      $pdflatex = "lualatex -synctex=1 %O %S";
      $pdf_mode = 1;
      $preview_continuous_mode = 1;
      $postscript_mode = $dvi_mode = 0;
      $silent = 0;
      $pdf_previewer = "zathura %O %S";
      $clean_ext = "bbl nav out snm";
    '';

    ".template".source = ./template;
  };
}
