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
}
