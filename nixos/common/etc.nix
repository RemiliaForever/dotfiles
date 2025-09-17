{ pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  # flydigi apex 5 elite gaming controller
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="37d7", ATTR{idProduct}=="2501", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.kmod}/bin/modprobe -i xpad && echo 37d7 2501 > /sys/bus/usb/drivers/xpad/new_id'"
  '';
}
