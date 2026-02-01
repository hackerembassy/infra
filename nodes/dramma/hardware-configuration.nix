{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "amdgpu" "radeon" ];
  #boot.initrd.kernelModules = [ "amdgpu" ];
  #boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  hardware.amdgpu.legacySupport.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a55b077b-fff6-476c-9d68-9b206d227ded";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C1D9-0E8D";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/3afc1e8f-a630-474d-9aad-587b08f36002"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ ];
  };
}
