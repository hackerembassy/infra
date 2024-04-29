{ config, pkgs, prelude, ... }@args:
let
  on = { enable = true; };
  iface = "enp0s18u1u1";
  conf = builtins.toFile "KlipperConfig.conf" ''
    [printer Anette]
    moonraker_host: localhost
    moonraker_port: 7125
    
    [printer Plumbus]
    moonraker_host: printer-plumbus.lan
    moonraker_port: 7125 
  '';
in

# Klipper and stuff around it.

{
  systemd.services.klipperscreen = {
    path = with pkgs; [ klipperscreen iproute2 ];
    script = ''
      export DISPLAY=$(ip r show dev ${iface} default | cut -d ' ' -f3):0
      echo Starting at $DISPLAY
      KlipperScreen -c ${conf}
    '';
    enable = true;
    after = [ "moonraker.service" "sys-subsystem-net-devices-${iface}.device" ];
    bindsTo = [ "sys-subsystem-net-devices-${iface}.device" ];
    partOf = [ "sys-subsystem-net-devices-${iface}.device" ];
    requires = [ "sys-subsystem-net-devices-${iface}.device" ];
    wantedBy = [ "sys-subsystem-net-devices-${iface}.device" ];
    serviceConfig.Restart = "always";
  };

  # systemd.services.klipperscreen-out = {
  #   path = with pkgs; [ klipperscreen iproute2 ];
  #   script = ''
  #     export DISPLAY=klipperphone.lan:0
  #     echo Starting at $DISPLAY
  #     KlipperScreen -c ${conf}
  #   '';
  #   enable = true;
  #   conflicts = [ "sys-subsystem-net-devices-${iface}.device" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.Restart = "always";
  # };
}
