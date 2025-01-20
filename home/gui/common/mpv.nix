{ pkgs, lib, ... }:

let
  glsl_prefix = "no-osd change-list glsl-shaders";
  mergeGLSL =
    shaders: text:
    glsl_prefix
    + " set \""
    + builtins.concatStringsSep ":" (builtins.map (s: "${pkgs.anime4k}/Anime4K_${s}.glsl") shaders)
    + "\"; show-text \"${text}\"";
in
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu";
      sub-auto = "fuzzy";
      save-position-on-quit = true;
      osc = "no";
    };
    extraInput = ''
      CTRL+0 ${glsl_prefix} clr ""; show-text "GLSL shaders cleared";
      CTRL+1 ${
        mergeGLSL [
          "Clamp_Highlights"
          "Restore_CNN_VL"
          "Upscale_CNN_x2_VL"
          "AutoDownscalePre_x2"
          "AutoDownscalePre_x4"
          "Upscale_CNN_x2_M"
        ] "Anime4K: 1080p (HQ)"
      }
      CTRL+2 ${
        mergeGLSL [
          "Clamp_Highlights"
          "Restore_CNN_Soft_VL"
          "Upscale_CNN_x2_VL"
          "AutoDownscalePre_x2"
          "AutoDownscalePre_x4"
          "Upscale_CNN_x2_M"
        ] "Anime4K: 720p (HQ)"
      }
      CTRL+3 ${
        mergeGLSL [
          "Clamp_Highlights"
          "Upscale_Denoise_CNN_x2_VL"
          "AutoDownscalePre_x2"
          "AutoDownscalePre_x4"
          "Upscale_CNN_x2_M"
        ] "Anime4K: 480p (HQ)"
      }
      CTRL+4 ${
        mergeGLSL [
          "Clamp_Highlights"
          "Restore_CNN_VL"
          "Upscale_CNN_x2_VL"
          "Restore_CNN_M"
          "AutoDownscalePre_x2"
          "AutoDownscalePre_x4"
          "Upscale_CNN_x2_M"
        ] "Anime4K: 1080p+ (HQ)"
      }
      CTRL+5 ${
        mergeGLSL [
          "Clamp_Highlights"
          "Restore_CNN_Soft_VL"
          "Upscale_CNN_x2_VL"
          "AutoDownscalePre_x2"
          "AutoDownscalePre_x4"
          "Restore_CNN_Soft_M"
          "Upscale_CNN_x2_M"
        ] "Anime4K: 720p+ (HQ)"
      }
      CTRL+6 ${
        mergeGLSL [
          "Clamp_Highlights"
          "Upscale_Denoise_CNN_x2_VL"
          "AutoDownscalePre_x2"
          "AutoDownscalePre_x4"
          "Restore_CNN_M"
          "Upscale_CNN_x2_M"
        ] "Anime4K: 480p+ (HQ)"
      }
    '';

    scripts = with pkgs.mpvScripts; [
      modernx-zydezu
      thumbfast
    ];
    scriptOpts = {
      modernx = {
        vidscale = false;
        scale_windowed = 2.0;
        scale_fullscreen = 2.0;
        scale_forcedwindow = 2.0;
      };
    };
  };
}
