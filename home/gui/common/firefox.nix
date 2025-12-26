{ pkgs, ... }:

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
        default = "google";
        engines = {
          nixos-packages = {
            name = "NixOS Packages";
            urls = [ { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          nixos-options = {
            name = "NixOS Options";
            urls = [ { template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          home-manager-options = {
            name = "HomeManager Options";
            urls = [
              { template = "https://home-manager-options.extranix.com?release=master&query={searchTerms}"; }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@ho" ];
          };
          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nw" ];
          };
          google.metaData.alias = "@g";
          baidu.metaData.hidden = true;
          bing.metaData.hidden = true;
          perplexity.metaData.hidden = true;
        };
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

        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = true;
        "gfx.webrender.all" = true;
        "dom.webgpu.enabled" = true;

        "network.trr.mode" = 5;
      };
    };
  };
  home.sessionVariables = {
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
