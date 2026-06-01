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
    version = "2.1.159";
    src =
      let
        inherit (final.stdenv.hostPlatform.node) platform arch;
      in
      final.fetchurl {
        url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/${platform}-${arch}/claude";
        sha256 =
          {
            "darwin-arm64" = "5adf7b4d349f743d669cd5adf2ce76dbb5e146d8ab99b3a63c5aef2ef15595f9";
            "darwin-x64" = "ababd6c754f7e028ab5e4bd74d4d6d3a802cafb57c9d41ea9178e897655c17bd";
            "linux-arm64" = "befd054f02c17e4b61a6a92b30286a147ca8c5c1bbf38b91dd14cba6fbb1e07d";
            "linux-x64" = "e2126caf00ed3ec09371a29947658c7e9b31185256b2ac5728263bd95f7e3541";
          }
          ."${platform}-${arch}";
      };
  });
}
