{ ... }:

{
  programs.firefox = {
    enable = true;
    policies = {
      HardwareAcceleration = true;
    };
    languagePacks = [ "zh-CN" ];
    profiles.remilia = {
      search = {
        force = true;
        default = "DuckDuckGo";
      };
      userChrome = ''
        #webrtcIndicator {
            display: none;
        }

        #TabsToolbar {
            visibility: collapse;
        }
      '';
      settings = {
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.system.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.compactmode.show" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = true;
        "gfx.webrender.all" = true;
      };
    };
  };
  home.sessionVariables = {
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
