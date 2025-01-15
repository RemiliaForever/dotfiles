{
  pkgs,
  config,
  lib,
  ...
}:

{
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

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
      #enable
      #autoStart
      desktopSession = "hyprland-uwsm";
      #environment
      #updater.splash
      user = "remilia";
    };
    steamos = {
      #useSteamOSConfig
      #enableAutoMountUdevRules
      #enableBluetoothConfig
      #enableDefaultCmdlineConfig
      #enableEarlyOOM
      enableMesaPatches = false; # TODO: fix patch upstream
      #enableProductSerialAccess
      #enableSysctlConfig
      #enableVendorRadv
      #enableZram
    };
    #workarounds.ignoreMissingKernelModules
  };
}
