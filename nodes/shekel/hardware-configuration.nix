{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  powerManagement.cpuFreqGovernor = "powersave";

  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=64M
  '';
  boot.initrd.checkJournalingFS = true;

}
