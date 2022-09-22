# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, prelude, ... }@args: with prelude args;

{

  imports = [ ./default.nix ./klipper.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";
  networking.useDHCP = false;

  networking.firewall.enable = false;
  services.xserver.xkbOptions = "ctrl:nocaps";

  hardware = { opengl.enable = true; };

  services.pipewire.enable = true;

  documentation.enable = false;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    zsh
  ];

}
