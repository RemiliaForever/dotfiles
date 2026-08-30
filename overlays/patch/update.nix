final: prev:

{
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

  claude-code = prev.claude-code.overrideAttrs (oldAttrs: rec {
    version = "2.1.251";
    src =
      let
        inherit (final.stdenv.hostPlatform.node) platform arch;
      in
      final.fetchurl {
        url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/${platform}-${arch}/claude";
        sha256 =
          {
            "darwin-arm64" = "625869b01e0050f260b2980fac248fd9cef9e462612bded4ec9d3d49ff8969a5";
            "darwin-x64" = "44221d72a3f35772faa85ad9a36a678084a516f720e64b45e26eb9015315500b";
            "linux-arm64" = "65445bd4dd042079cc3fa43791b561370a05c8599e8ec47580e25a81050abbdd";
            "linux-x64" = "fd5f10ff0eb58daec04900466b143ea98aab50abf208a422bc008eaec13f61f7";
          }
          ."${platform}-${arch}";
      };
  });
}
