{ config, lib, pkgs, ... }:

{

  services.node-red = {
    # enable = true;
  };
  services.mosquitto  = {
    settings = {
    };
    enable = true;
    listeners = [
      {
        users = {
          "admin" = {
            acl = [ "readwrite door/#" ];
            passwordFile = "/secrets/mqtt-admin-user.txt";
          };
          "door" = {
            acl = [ "readwrite door/#" ];
            passwordFile = "/secrets/mqtt-door-user.txt";
          };
        };
      }
    ];
  };

}
