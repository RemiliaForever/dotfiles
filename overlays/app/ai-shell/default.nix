{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  ...
}:

buildNpmPackage rec {
  pname = "ai-shell";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "BuilderIO";
    repo = "ai-shell";
    tag = "v${version}";
    hash = "sha256-zRJF1yruQdsocAEWfEQS2eZOBg0a63GelkPyDcin2qM=";
  };

  npmDepsHash = "sha256-NJHWm0iihZuTig22Amh2gI1uDEGmREQtSS+9tdr6AFk=";

  meta = {
    description = "A CLI that converts natural language to shell commands. ";
    homepage = "https://github.com/BuilderIO/ai-shell";
    license = lib.licenses.mit;
  };
}
