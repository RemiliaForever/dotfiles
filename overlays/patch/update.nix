final: prev:

{
  adwsteamgtk = prev.adwsteamgtk.overrideAttrs (_: {
    version = "0.9.1";
    src = prev.fetchFromGitHub {
      owner = "Foldex";
      repo = "AdwSteamGtk";
      tag = "v0.9.1";
      hash = "sha256-ICDagK/vklptnn9NjVMNLkflfwKxlyeWfMqp/pvZLTE=";
    };
  });

  wechat =
    if final.stdenvNoCC.hostPlatform.system == "x86_64-linux" then
      final.callPackage (prev.path + "/pkgs/by-name/we/wechat/linux.nix") {
        inherit (prev.wechat) meta version;
        pname = "wechat";
        src = final.fetchurl {
          url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
          hash = "sha256-T1StKQLs1vb9xWgLc1R/gNVCO/RwsBI3pXmi5bPK7us=";
        };
      }
    else
      prev.wechat;

  pi-coding-agent = prev.pi-coding-agent.overrideAttrs (_: rec {
    version = "1.4.0";
    src = prev.fetchFromGitHub {
      owner = "earendil-works";
      repo = "pi";
      tag = "v${version}";
      hash = "sha256-N9NOpiiZTbOMDMV+CxvJAgtLjJJ1/8NJBGS0cFHkhsc=";
    };
    modelData = prev.fetchurl {
      url = "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-${version}.tgz";
      hash = "sha256-tA4rqLtvwzKQj4uW6DfcLR/ftF65zTgvWu0RFGKYHjw=";
    };
    npmDepsHash = "sha256-aBzVz78IxZQlzPYC72Ufa2YFtkow6nZR24YBYZrv9W0=";
    npmDeps = prev.fetchNpmDeps {
      name = "pi-coding-agent-${version}-npm-deps";
      inherit src;
      hash = npmDepsHash;
    };
    postInstall = ''
      local nm="$out/lib/node_modules/pi-monorepo/node_modules"

      for ws in @earendil-works/chord:packages/chord \
                @earendil-works/pi-ai:packages/ai \
                @earendil-works/pi-agent-core:packages/agent \
                @earendil-works/pi-codemode:packages/codemode \
                @earendil-works/pi-durable:packages/durable \
                @earendil-works/pi-env:packages/env \
                @earendil-works/pi-mcp:packages/mcp \
                @earendil-works/pi-telemetry:packages/telemetry \
                @earendil-works/pi-tui:packages/tui; do
        IFS=: read -r pkg src <<< "$ws"
        rm "$nm/$pkg"
        cp -r "$src" "$nm/$pkg"
      done

      find "$nm" -type l -lname '*/packages/*' -delete
      find "$nm/.bin" -xtype l -delete
    ''
    + prev.lib.optionalString prev.stdenvNoCC.hostPlatform.isDarwin ''
      rm -rf \
        "$nm/@anthropic-ai/sandbox-runtime/dist/vendor/seccomp" \
        "$nm/@anthropic-ai/sandbox-runtime/vendor/seccomp"
    '';
  });
}
