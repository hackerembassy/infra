{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  powerManagement.cpuFreqGovernor = "powersave";

  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=64M
  '';
  boot.initrd.checkJournalingFS = true;
  boot.kernelParams = [ "brcmfmac.feature_disable=0x82000" "brcmfmac.roamoff=1" ];

}
