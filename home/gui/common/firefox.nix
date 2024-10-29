{ ... }:

{
  programs.firefox = {
    enable = true;
    policies = {
      HardwareAcceleration = true;
    };
    profiles.remilia = {
      #search.default = "DuckDuckGo";
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

        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = true;
        "gfx.webrender.all" = true;
      };
    };
  };
}
