{ config, pkgs, prelude, ... }@args: with prelude args;
{
  hardware.bluetooth.enable = true;
  services = {
    avahi = on;
 };
}
