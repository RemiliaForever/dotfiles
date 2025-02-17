{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host ryzen
          HostName 172.18.10.1
          User remilia

      Host console
          HostName 172.18.10.2
          User remilia

      Host surface
          HostName 172.18.10.3
          User remilia

      Host deck
          HostName 172.18.10.4
          User remilia
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
