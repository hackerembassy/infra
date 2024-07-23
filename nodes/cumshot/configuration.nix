{ config, pkgs, prelude, ... }@args: with prelude args;
{

  imports = [
     ./default.nix
     ./tailscale.nix
    #  ./dex.nix
     ./outline.nix
  ];

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";
  networking.useDHCP = false;

  networking.firewall.enable = false;


  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nano
    htop
    btop
    strace
    headscale
    wget
    zsh
  ];

}
