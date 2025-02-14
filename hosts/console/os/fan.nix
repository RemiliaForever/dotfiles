{ ... }:

{
  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=2

      DEVPATH=hwmon2=devices/platform/nct6775.2592
      DEVNAME=hwmon2=nct6798

      FCTEMPS=hwmon2/pwm1=/sys/devices/platform/coretemp.0/hwmon/[[:print:]]*/temp1_input hwmon2/pwm2=/sys/devices/platform/coretemp.0/hwmon/[[:print:]]*/temp1_input hwmon2/pwm6=/sys/devices/platform/coretemp.0/hwmon/[[:print:]]*/temp1_input
      FCFANS=hwmon2/pwm1=hwmon2/fan1_input hwmon2/pwm2=hwmon2/fan2_input hwmon2/pwm6=hwmon2/fan6_input
      MINTEMP=hwmon2/pwm1=40 hwmon2/pwm2=40 hwmon2/pwm6=40
      MAXTEMP=hwmon2/pwm1=90 hwmon2/pwm2=90 hwmon2/pwm6=90
      MINSTART=hwmon2/pwm1=30 hwmon2/pwm2=30 hwmon2/pwm6=30
      MINSTOP=hwmon2/pwm1=30 hwmon2/pwm2=30 hwmon2/pwm6=30
      MINPWM=hwmon2/pwm1=30 hwmon2/pwm2=30 hwmon2/pwm6=30
      MAXPWM=hwmon2/pwm1=255 hwmon2/pwm2=255 hwmon2/pwm6=255
    '';
  };
}
