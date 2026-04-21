final: prev:

{
  wiliwili = prev.wiliwili.overrideAttrs (oldAttrs: {
    version = "aa1f157";
    src = final.fetchFromGitHub {
      owner = "xfangfang";
      repo = "wiliwili";
      rev = "aa1f157540c2c1b824605cdbdfb78cb072ffb6bd";
      fetchSubmodules = true;
      hash = "sha256-TOTo3Oyf2vWqOz/Jn1+o7I0ym8DM6+lzy/jDq1uAnFw=";
    };
  });

  claude-code-bin = prev.claude-code-bin.overrideAttrs (
    oldAttrs:
    let
      baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
      platformKey = "${final.stdenv.hostPlatform.node.platform}-${final.stdenv.hostPlatform.node.arch}";
    in
    rec {
      version = "2.1.116";
      src = final.fetchurl {
        url = "${baseUrl}/${version}/${platformKey}/claude";
        sha256 = "sha256-DRrqXOBWpc5JHafpu+Y/mSWF5cJIUvAjoHyPGM8pLMU=";
      };
    }
  );
}
