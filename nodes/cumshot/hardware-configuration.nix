# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  boot.isContainer = true;

  imports =
    [ (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ];

  services.fstrim.enable = true;

}
