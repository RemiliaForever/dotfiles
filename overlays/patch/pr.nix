final: prev:

{
  hyprlandPlugins = prev.hyprlandPlugins // {
    hyprspace = prev.hyprlandPlugins.hyprspace.overrideAttrs (old: {
      postPatch = ''
        substituteInPlace src/Globals.hpp \
          --replace-fail "<hyprland/src/managers/AnimationManager.hpp>" "<hyprland/src/managers/animation/AnimationManager.hpp>"
      '';
    });
    hyprsplit = prev.hyprlandPlugins.hyprsplit.overrideAttrs (old: rec {
      version = "0.51.0";
      src = final.fetchFromGitHub {
        owner = "shezdy";
        repo = "hyprsplit";
        tag = "v${version}";
        hash = "sha256-h6vDtBKTfyuA/6frSFcTrdjoAKhwlGBT+nzjoWf9sQE=";
      };
    });
  };
}
