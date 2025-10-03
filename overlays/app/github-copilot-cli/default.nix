{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "github-copilot-cli";
  version = "0.0.332";

  src = fetchzip {
    url = "https://registry.npmjs.org/@github/copilot/-/copilot-${version}.tgz";
    hash = "sha256-PdArjaeWpPih2MgQIm5kzWxmf0HlUE85u/R8kzdopks=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-gO6OkbtSMLK4WJAF6zpdoaOiM1ABx0oEKhVq0mPZ2OI=";

  dontNpmBuild = true;
}
