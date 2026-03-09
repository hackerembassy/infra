{ config, pkgs, prelude, ... }@args:
let
  on = { enable = true; };
in

# Klipper and stuff around it.

{
  imports = [ ./klipperscreen.nix ];

  users.users.klipper = {
    isSystemUser = true;
    group = "klipper";
  };

  users.groups.klipper = {};

  security.polkit = on;

  #  Actually, /var/lib/klipper will be taken over by moonraker
  # /var/lib/klipper/config will contain both klipper and moonraker configs

  services.klipper = on // {
    user = "klipper";
    group = "klipper";
    configFile = ./printer.cfg;
    mutableConfig = true;
    mutableConfigFolder = "/var/lib/klipper/config";
    firmwares = {
      anette-main = {
        serial = "/dev/serial/by-id/usb-Klipper_lpc1769_12345-if00";
        configFile = ./anette.main.config;
      };
    };
  };
   systemd.services.klipper.serviceConfig.ExecStart = pkgs.lib.mkForce "/nix/store/v4n4sj7sab3g4p3ll0icvc462vj63nj3-klipper-0.13.0-unstable-2025-11-17/bin/klippy --input-tty=/run/klipper/tty --api-server=/run/klipper/api -l /var/lib/klipper/logs/klippy.log /var/lib/klipper/config/printer.cfg";

  services.moonraker = on // {
    user = "klipper";
    group = "klipper";
    address = "0.0.0.0";
    allowSystemControl = true;
    stateDir = "/var/lib/klipper";
    settings = {
	server = {
	  log_path = "var/lib/klipper/logs";
	          };
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
}
