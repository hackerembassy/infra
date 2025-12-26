{ config, pkgs, prelude, ... }@args:
let
  on = { enable = true; };
  iface = "enp0s16u1";
  conf = builtins.toFile "KlipperScreen.conf" ''
    [main]
    use_dpms: False

    [printer Anette]
    moonraker_host: localhost
    moonraker_port: 7125
  '';
in

# Klipper and stuff around it.

{
  systemd.services.klipperscreen = {
    path = with pkgs; [ klipperscreen iproute2 xorg.xset xorg.xsetroot ];
    script = ''
      export DISPLAY=$(ip r show dev ${iface} default | cut -d ' ' -f3):0
      echo "--- starting at DISPLAY=$DISPLAY ---"
      KlipperScreen -c ${conf} -l -
    '';
    enable = true;
    after = [ "moonraker.service" "sys-subsystem-net-devices-${iface}.device" ];
    bindsTo = [ "sys-subsystem-net-devices-${iface}.device" ];
    partOf = [ "sys-subsystem-net-devices-${iface}.device" ];
    requires = [ "sys-subsystem-net-devices-${iface}.device" ];
    wantedBy = [ "sys-subsystem-net-devices-${iface}.device" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = "10";
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
