final: prev:

{
  telegram-desktop = prev.telegram-desktop.override {
    unwrapped = prev.telegram-desktop.unwrapped.overrideAttrs (_: rec {
      version = "7.2.5";
      src = final.fetchFromGitHub {
        owner = "telegramdesktop";
        repo = "tdesktop";
        rev = "v${version}";
        fetchSubmodules = true;
        hash = "sha256-S4sS+stMXvoYFQVXO8MVjIJUzsQa1D9zTAEDwQ/R1h4=";
      };
    });
  };

  wiliwili = prev.wiliwili.overrideAttrs (oldAttrs: {
    version = "1.6.0";
    src = final.fetchFromGitHub {
      owner = "xfangfang";
      repo = "wiliwili";
      tag = "v1.6.0";
      fetchSubmodules = true;
      hash = "sha256-J6oUMUzfogsIBj1GpwWmKhjphTV628rG+3w28Dc81Fw=";
    };
  });

  pi-coding-agent = prev.pi-coding-agent.overrideAttrs (oldAttrs: rec {
    version = "0.85.1";
    src = final.fetchFromGitHub {
      owner = "earendil-works";
      repo = "pi";
      tag = "v${version}";
      hash = "sha256-gU8BSiqqOYt2RRuQONHHGvZeSM5KFQVrwif9bmuUXUc=";
    };
    npmDepsHash = "sha256-jzlsZIQzfl1FCZZ5//dHFWwMfBZQ4nRD6KB4HHifPqE=";
    npmDeps = final.fetchNpmDeps {
      inherit src;
      name = "pi-coding-agent-${version}-npm-deps";
      hash = npmDepsHash;
    };
    modelData = final.fetchurl {
      url = "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-${version}.tgz";
      hash = "sha256-r30RmGF5RFzm/oizfVfeIvgjwP/TplyuMcVVt/XpklM=";
    };
    preConfigure = ''
      mkdir -p packages/ai/src/providers/data
      tar --extract --gzip --file=${modelData} \
        --directory=packages/ai/src/providers/data \
        --strip-components=4 \
        package/dist/providers/data
    '';
    npmWorkspace = "packages/coding-agent";
    npmRebuildFlags = [ "--ignore-scripts" ];
    buildPhase = ''
      runHook preBuild
      npx tsgo -p packages/chord/tsconfig.build.json
      npx tsgo -p packages/tui/tsconfig.build.json
      npx tsgo -p packages/telemetry/tsconfig.build.json
      npx tsgo -p packages/ai/tsconfig.build.json
      npx tsgo -p packages/agent/tsconfig.build.json
      npx tsgo -p packages/protocol/tsconfig.build.json
      npx tsgo -p packages/client/tsconfig.build.json
      npx tsgo -p packages/server/tsconfig.build.json
      npm run build --workspace=packages/coding-agent
      runHook postBuild
    '';
    dontNpmPrune = true;
    preInstall = ''
      npm prune --omit=dev --no-save
    '';
    postInstall = ''
      local nm="$out/lib/node_modules/pi-monorepo/node_modules"

      for ws in @earendil-works/chord:packages/chord \
                @earendil-works/pi-ai:packages/ai \
                @earendil-works/pi-agent-core:packages/agent \
                @earendil-works/pi-client:packages/client \
                @earendil-works/pi-protocol:packages/protocol \
                @earendil-works/pi-telemetry:packages/telemetry \
                @earendil-works/pi-tui:packages/tui; do
        IFS=: read -r pkg src <<< "$ws"
        rm "$nm/$pkg"
        cp -r "$src" "$nm/$pkg"
      done

      find "$nm" -type l -lname '*/packages/*' -delete
      find "$nm/.bin" -xtype l -delete
    '' + final.lib.optionalString final.stdenvNoCC.hostPlatform.isDarwin ''
      rm -rf \
        "$nm/@anthropic-ai/sandbox-runtime/dist/vendor/seccomp" \
        "$nm/@anthropic-ai/sandbox-runtime/vendor/seccomp"
    '';
  });
}
