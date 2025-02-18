# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.printit.nixosModules.aarch64-linux.default
      inputs.rpi-nix.nixosModules.raspberry-pi
      inputs.rpi-nix.nixosModules.sd-image
      "${inputs.self}/modules/"
      "${inputs.self}/modules/tmplog.nix"
    ];

  raspberry-pi-nix = {
    board = "bcm2711";
    libcamera-overlay.enable = false;
  };

  services.tailscale.enable = true;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";

  services.avahi.enable = true;

  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "ctrl:nocaps";

  services.printing.enable = true;

  services.pipewire.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" "video" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      waypipe
    ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    uhubctl
    ffmpeg
    gphoto2
  ];

  services.openssh.enable = true;
  networking.firewall.enable = false;

  users.users.root.hashedPassword = "$y$j9T$q4c/.wjNYg7nzUL4/38Ef0$P0nfnjRF/GZRxcLfeDkHupcoZWnr7fP.KvzpB1TiqY.";

  # Printer udev rule
  services.udev.extraRules = ''
    ATTR{idVendor}=="04f9", ATTR{idProduct}=="2016", GROUP="wheel"
  '';

}

