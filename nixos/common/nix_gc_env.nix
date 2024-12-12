{
  pkgs,
  config,
  lib,
  ...
}:

let
  conf = config.nix.gc;

  clean_profiles = pkgs.writeShellScript "clean_profiles.sh" ''
    set -e

    PATH="${pkgs.nix}/bin:$PATH"
    DELETE_GENERATIONS_ARG=${lib.escapeShellArg conf.delete_generations}

    profiles=()

    find_profiles ()
    {
      echo "Looking for profiles in $1" >&2
      for p in "$1"/*; do
        if [[ -L $p ]] && ! [[ $p = *-link ]]; then profiles+=("$p"); fi
      done
    }

    find_profiles "/nix/var/nix/profiles"
    for pu in /nix/var/nix/profiles/per-user/*; do
      find_profiles "$pu"
    done
    for pu in /home/*/.local/state/nix/profiles; do
      find_profiles "$pu"
    done


    nix_env_print ()
    {
      echo nix-env "$@"
      nix-env "$@"
    }

    for p in "''${profiles[@]}"; do
      nix_env_print --profile "$p" --delete-generations "$DELETE_GENERATIONS_ARG"
    done
  '';

in
{
  options.nix.gc = {
    delete_generations = lib.mkOption {
      type = lib.types.str;
      default = "+5";
      example = "+5";
      description = ''
        Argument passed to [nix-env --delete-generations]. The default of '+5'
        means to keep the 5 most recent generations of each profiles.
      '';
    };
  };

  config = lib.mkIf (conf.delete_generations != null) {
    assertions = [
      {
        assertion = config.nix.gc.automatic;
        message = "'nix.gc.delete_generations' requires 'nix.gc.automatic' to be 'true'.";
      }
    ];

    systemd.services.nix_gc_env = {
      wantedBy = [ "nix-gc.service" ];
      before = [ "nix-gc.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = clean_profiles;
      };
    };
  };
}
