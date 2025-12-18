final: prev:

{
  # apply patch to niri
  niri = prev.niri.overrideAttrs (oldAttrs: {
    patches =
      oldAttrs.patches or [ ]
      ++
      # https://github.com/YaLTeR/niri/pull/2609
      [
        ./niri/0001-add-feat-force-render.patch
        ./niri/0002-Unify-force-render-logic-and-ensure-each-window-uses.patch
      ];
  });

  # https://github.com/NixOS/nixpkgs/pull/468130
  clang-tools = prev.clang-tools.overrideAttrs (oldAttrs: {
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin

      for tool in $unwrapped/bin/clang-*; do
        tool=$(basename "$tool")

        # Compilers have their own derivation, no need to include them here:
        if [[ $tool == "clang-cl" || $tool == "clang-cpp" ]]; then
          continue
        fi

        # Clang's derivation produces a lot of binaries, but the tools we are
        # interested in follow the `clang-something` naming convention - except
        # for clang-$version (e.g. clang-13), which is the compiler again:
        if [[ ! $tool =~ ^clang\-[a-zA-Z_\-]+$ ]]; then
          continue
        fi

        ln -s $out/bin/clangd $out/bin/$tool
      done

      if [[ -z "$(ls -A $out/bin)" ]]; then
        echo "Found no binaries - maybe their location or naming convention changed?"
        exit 1
      fi

      substituteAll ${./clang-tools/wrapper} $out/bin/clangd
      chmod +x $out/bin/clangd

      runHook postInstall
    '';
  });
}
