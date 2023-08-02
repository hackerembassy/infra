{ config, pkgs, prelude, ... }@args: let
  on = { enable = true; };
in

# Klipper and stuff around it.

  {
    users.users.klipper = {
    isSystemUser = true;
    group = "klipper";
  };

  users.groups.klipper = {};

  security.polkit = on;
  
  services.klipper = on // {
    user = "klipper";
    group = "klipper";
    configFile = ./printer.cfg;
    mutableConfig = true;
    firmwares = {
      anette-main = on // {
        serial = "/dev/serial/by-id/usb-Klipper_lpc1769_12345-if00";
        configFile = ./anette.main.config;
      };
    };
  };

  services.moonraker = on // {
    user = "klipper";
    group = "klipper";
    address = "0.0.0.0";
    allowSystemControl = true;
    settings = {
        authorization = {
          cors_domains = [
            "http://${config.networking.hostName}"
            "http://${config.networking.hostName}.lan"
            "http://${config.networking.hostName}.local"
            "http://localhost"
            "http://app.fluidd.xyz"
            "http://my.mainsail.xyz"
      	    "http://le-fail.lan"
      	    "http://printer-anette.lan"
          ];
          trusted_clients = [ "0.0.0.0/0" "::0/0" ];
        };
        file_manager = {
          enable_object_processing = "False";
        };
        octoprint_compat = { };
      };
  };
  services.fluidd = on // {
    nginx = {
      extraConfig = ''
        client_max_body_size 1G;
      '';
      locations."/webcam".proxyPass = "http://127.0.0.1:8080/stream";
    };
  };

  systemd.services.klippercam = {
    script = "${pkgs.ustreamer}/bin/ustreamer -f 15 -s 0"; 
    enable = true;
    after = [ "network.target" ];
  };

  systemd.services.klipperscreen = let 
    iface = "enp0s20u5";
    conf = builtins.toFile "KlipperConfig.conf" ''
      [printer Anette]
      moonraker_host: localhost
      moonraker_port: 7125
      
      [printer Plumbus]
      moonraker_host: printer-plumbus.lan
      moonraker_port: 7125 
    '';
  in {
    path = with pkgs; [ klipperscreen iproute2 ];
    script = ''
      export DISPLAY=$(ip r show dev ${iface} default | cut -d ' ' -f3):0
      echo Starting at $DISPLAY
      KlipperScreen -c ${conf}
    ''; 
    enable = true;
    after = [ "moonraker.service" "sys-subsystem-nE${iface}t-devices-${iface}.device" ];
    bindsTo = [ "sys-subsystem-net-devices-${iface}.device" ];
    partOf = [ "sys-subsystem-net-devices-${iface}.device" ];
    requires = [ "sys-subsystem-net-devices-${iface}.device" ];
    wantedBy = [ "sys-subsystem-net-devices-${iface}.device" ];
    serviceConfig.Restart = "always";
  };
  
}
