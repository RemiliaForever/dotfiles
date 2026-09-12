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

}
