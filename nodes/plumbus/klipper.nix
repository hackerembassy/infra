{ config, pkgs, prelude, ... }@args:
let
  on = { enable = true; };
in

# Klipper and stuff around it.

{

  users.users.klipper = {
    isSystemUser = true;
    group = "klipper";
  };
  users.groups.klipper = { };

  security.polkit = on;

  # nixpkgs.overlays = [
  #   (super: self: {
  #     klipper = self.klipper.overrideAttrs {
  #       version = "fucking-adc";
  #       src = 
  #         self.fetchFromGitHub {
  #           owner = "klipper3d";
  #           repo = "klipper";
  #           rev = "6cd174208bd9bbd51dc0d519a26661fb926d038a";
  #           hash = "sha256-mIBJtrkh+SIGx9s+ZyUcn0343HEkGN8i0N/Ap/AETVs=";
  #         }
  #       ;
  #     };
  #   })

  # ];

  services.klipper = on // {
    user = "klipper";
    group = "klipper";
    configFile = ./printer.cfg;
    mutableConfig = true;
    mutableConfigFolder = "/var/lib/klipper/config";
    firmwares = {
      plumbus = {
        enableKlipperFlash = true;
        serial = "/dev/serial/by-id/usb-Klipper_sam4e8e_003230533750414D3135303336303534-if00";
        configFile = ./plumbus.cfg;
      };
    };
  };

  services.moonraker = on // {
    user = "klipper";
    group = "klipper";
    address = "0.0.0.0";
    allowSystemControl = true;
    stateDir = "/var/lib/klipper";
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
          "http://printer-plumbus.lan"
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
