# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, prelude, ... }@args: with prelude args;

{

  imports = [ 
     ./default.nix 
  ];

  networking.networkmanager.enable = true;
  services.headscale = {
    enable = true;
    settings = {
      server_url = "https://tail.hackem.cc";
      listen_addr = "0.0.0.0:8888";
      ip_prefixes = [
        "100.64.0.0/16"
        "fd7a:115c:a1e0::/48"
      ];
      dns_config = {
        magic_dns = true;
        nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
        base_domain = "hackem";
        domains = [
          "lan"
        ];
        restricted_nameservers = {
          "lan" = [
            "192.168.1.1"
          ];
        };
      };
    };
  };

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