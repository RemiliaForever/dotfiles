{ pkgs, config, ... }:

{
  programs.steam.fontPackages = config.fonts.packages;
  jovian = {
    decky-loader = {
      #enable
      #extraPackages
      #extraPythonPackages
      #package
      #stateDir
      #user
    };
    devices.steamdeck = {
      #enable
      #autoUpdate
      #enableControllerUdevRules
      #enableDefaultCmdlineConfig
      #enableDefaultStage1Modules
      #enableFwupdBiosUpdates
      #enableGyroDsuService
      #enableKernelPatches
      #enableOsFanControl
      #enablePerfControlUdevRules
      #enableSoundSupport
      #enableXorgRotation
    };
    hardware = {
      #has.amd.gpu
      #amd.gpu.enableBacklightControl
      #amd.gpu.enableEarlyModesetting
    };
    steam = {
      enable = true;
      #autoStart
      desktopSession = "hyprland";
      #environment
      #updater.splash
      user = "remilia";
    };
    steamos = {
      useSteamOSConfig = false;
      enableAutoMountUdevRules = true;
      enableBluetoothConfig = true;
      #enableDefaultCmdlineConfig
      #enableEarlyOOM
      enableMesaPatches = true;
      #enableProductSerialAccess
      #enableSysctlConfig
      #enableVendorRadv
      #enableZram
    };
    #workarounds.ignoreMissingKernelModules
  };
}
