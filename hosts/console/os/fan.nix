{ pkgs, ... }:

let
  settingsFormat = pkgs.formats.yaml { };
  fanctlConfig = settingsFormat.generate "fanctl.yaml" {
    interval = 1000;
    log_interval = 200;
    inputs = {
      gpu_temp.HwmonSensor = {
        hwmon = "amdgpu";
        label = "junction";
      };
      cpu_temp.HwmonSensor = {
        hwmon = "coretemp";
        label = "Package id 0";
      };
    };
    outputs = {
      gpu_fan.PwmFan = {
        hwmon = "amdgpu";
        name = "pwm1";
      };
      sys_fan1.PwmFan = {
        hwmon = "nct6798";
        name = "pwm1";
      };
      sys_fan2.PwmFan = {
        hwmon = "nct6798";
        name = "pwm2";
      };
      sys_fan6.PwmFan = {
        hwmon = "nct6798";
        name = "pwm6";
      };
    };
    rules = [
      {
        outputs = [ "gpu_fan" ];
        rule.Maximum = [
          {
            GateCritical = {
              input = "gpu_temp";
              value = 1.0;
            };
          }
          {
            Curve = {
              input = "gpu_temp";
              keys = [
                {
                  input = 0.0;
                  output = 0.0;
                }
                {
                  input = 50.0;
                  output = 0.0;
                }
                {
                  input = 70.0;
                  output = 0.4;
                }
                {
                  input = 95.0;
                  output = 1.0;
                }

              ];
            };
          }
        ];
      }
      {
        outputs = [
          "sys_fan1"
          "sys_fan2"
          "sys_fan6"
        ];
        rule.Maximum = [
          {
            GateCritical = {
              input = "cpu_temp";
              value = 1.0;
            };
          }
          {
            Curve = {
              input = "cpu_temp";
              keys = [
                {
                  input = 0.0;
                  output = 0.0;
                }
                {
                  input = 50.0;
                  output = 0.0;
                }
                {
                  input = 60.0;
                  output = 0.4;
                }
                {
                  input = 80.0;
                  output = 1.0;
                }
              ];
            };
          }
        ];
      }
    ];
  };
in
{

  systemd.services.fanctl = {
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.fanctl}/bin/fanctl -c ${fanctlConfig}";
      RestartSec = "5s";
    };
    wantedBy = [ "multi-user.target" ];
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];
}
