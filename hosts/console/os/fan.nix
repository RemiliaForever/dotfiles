{ pkgs, ... }:

{

  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=2

      DEVPATH=hwmon1=devices/platform/nct6775.2592
      DEVNAME=hwmon1=nct6798

      FCTEMPS=hwmon1/pwm1=/sys/devices/platform/coretemp.0/hwmon/[[:print:]]*/temp1_input hwmon1/pwm2=/sys/devices/platform/coretemp.0/hwmon/[[:print:]]*/temp1_input hwmon1/pwm6=/sys/devices/platform/coretemp.0/hwmon/[[:print:]]*/temp1_input
      FCFANS=hwmon1/pwm1=hwmon1/fan1_input hwmon1/pwm2=hwmon1/fan2_input hwmon1/pwm6=hwmon1/fan6_input
      MINTEMP=hwmon1/pwm1=10 hwmon1/pwm2=10 hwmon1/pwm6=10
      MAXTEMP=hwmon1/pwm1=90 hwmon1/pwm2=90 hwmon1/pwm6=90
      MINSTART=hwmon1/pwm1=30 hwmon1/pwm2=30 hwmon1/pwm6=30
      MINSTOP=hwmon1/pwm1=30 hwmon1/pwm2=30 hwmon1/pwm6=30
      MINPWM=hwmon1/pwm1=30 hwmon1/pwm2=30 hwmon1/pwm6=30
      MAXPWM=hwmon1/pwm1=255 hwmon1/pwm2=255 hwmon1/pwm6=255
    '';
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];
  services.lact.enable = true;
}
