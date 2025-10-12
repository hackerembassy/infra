args @ { config, pkgs, lib, inputs, prelude, ... }:
with prelude args; {

  console = {
    colors = [
        "3A3C43" "BE3E48" "869A3A" "C4A535" "4E76A1" "855B8D" "568EA3" "B8BCB9"
        "888987" "FB001E" "0E712E" "C37033" "176CE3" "FB0067" "2D6F6C" "FCFFB8"
    ];
    font = "Lat2-Terminus16";
    useXkbConfig = true; # ctrl:nocaps at last
  };


  i18n.defaultLocale = "C.UTF-8";

  services = {

    avahi = on;
    fwupd = on;

    openssh = on // {
      settings.PasswordAuthentication = false;
    };

    xserver = {
      layout = "us,ru";
      xkbOptions = "ctrl:nocaps,lv3:ralt_switch_multikey,misc:typo,grp:win_space_toggle";
    };
  };

  users = {
    mutableUsers = false;
    users.root = {
      shell = pkgs.zsh;
      # isNormalUser = true;
      # isSystemUser = false;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXIhiha4PKZNsC36QP/a1/0f8l8igJnc00lJzfRzmuf nick@CMDB-175087.lan"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJprtCdLq8X4sYWZp3loq69iED8h1YEvfe2j3vUEIsVy dipierro@MacBook-Pro.lan"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzq8bOBNIPlerchHLHR7CMMHwNBPIWcNYxwS+Gui4eC/HtzWNelwWspKywxxWXtLuRrOYZMJAP5DqbvA8OONYMrRpEYzmCHPdWbB7UT6UMiTtFWxWwuo05YWhLA4BxharWArU3Vkiv0ExYYtmwGcTQqsRxVhJB7Pk/D11y28Jvb1UjsYglnPuWDjMMQVHgs26DKIKHosuAvHg6GyJjFDNTcRjlFpEcJdDLGyvh9z+I9M540JF87+/VhZ+oAUrwihn3NVWhMIQXyTVnV/Mp8miOFuBuGRu8z1Qn5i1MX4ml2MqTPQ+tiZkSOb1eBy50c8iumm29nr/tejBYdBTw8pW22IxESbtCe3HDw+wdsV9vU/M+JYEBBVkUFk7gNfOxHyixriAIuJuG7OytCZ1SdCXbS4VvXBpRxEF4SYGXcX58KXnxQd97gJ8Nq0qgXiZsjh+i5YH9e0xgUBrHfPkR6tB+L0d/s0IkSqaE0/D9jmSt7Be/PXIbw4xTZ+4EmMBaVZE= netBUG"
      ];
    };
  };


}
