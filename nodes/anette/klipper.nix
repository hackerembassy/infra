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
      anette = on // {
        serial = "/dev/serial/by-id/usb-Klipper_lpc1769_12345-if00";
        configFile = ./.config;
      };
    };
  };

  services.moonraker = on // {
    user = "klipper";
    group = "klipper";
    address = "0.0.0.0";
    allowSystemControl = true;
    configDir = "/var/lib/klipper";
    settings = {
        server.enable_debug_logging = true;
        authorization = {
          cors_domains = [
            "http://${config.networking.hostName}"
            "http://${config.networking.hostName}.lan"
            "http://${config.networking.hostName}.local"
            "http://localhost"
            "http://app.fluidd.xyz"
            "http://my.mainsail.xyz"
          ];
          trusted_clients = [ "0.0.0.0/0" ];
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

}
