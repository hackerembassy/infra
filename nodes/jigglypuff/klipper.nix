{ config, pkgs, prelude, ... }@args: with prelude args;

# Klipper and stuff around it.

{

#  boot.kernelPackages = pkgs.linuxPackages-rt;

  users.users.klipper = {
    isSystemUser = true;
    group = "klipper";
  };
  users.groups.klipper = {};

  security.polkit = on;

  services.klipper = on // {
    user = "klipper";
    group = "klipper";
    configFile = "${args.inputs.printer-anette}/config.cfg";
    mutableConfig = true;
    firmwares = {
      anette = {
        serial = "/dev/serial/by-id/usb-Klipper_lpc1769_12345-if00";
        configFile = "${args.inputs.printer-anette}/.config";
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
    nginx.extraConfig = ''
      client_max_body_size 1G;
    '';
  };

}
