{ pkgs, ... }:

{
  feishu = pkgs.callPackage ./feishu { };
  wechat = pkgs.callPackage ./wechat { };
}
