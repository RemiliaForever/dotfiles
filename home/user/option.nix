{ lib, ... }:

{
  options.remilia = {
    cuda = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable cuda";
    };
    rocm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable rocm";
    };
  };
}
