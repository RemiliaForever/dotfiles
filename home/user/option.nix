{ lib, ... }:

{
  options.remilia.cuda = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable cuda";
  };
  options.remilia.rocm = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable rocm";
  };
}
