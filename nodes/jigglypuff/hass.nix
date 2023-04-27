{ config, pkgs, prelude, ... }@args: with prelude args;
{
  hardware.bluetooth.enable = true;
  services = {
    avahi = on;

    home-assistant = on // {
      configWritable = true;
#      openFirewall = true;
      lovelaceConfigWritable = true;

      config = null;
#      config = {
#        default_config = {};
#        homeassistant = {
#          name = "Hacker Embassy";
#          unit_system = "metric";
#          time_zone = "Asia/Yerevan";
#        };
#        #binary_sensor = [
#        #  { platform = "ffmpeg_motion"; input = "/dev/video2";  }
#        #];
#        sensor = [
#          { platform = "linux_battery"; }
#        ];
#        ffmpeg = {
#
#        };
#
#        http = { };
#      };

      extraComponents = [
        "homekit"
	"homekit_controller"
	"apple_tv"
	"bthome"
	"telegram"
	"telegram_bot"
        "default_config"
        "analytics"
	"backup"
	"camera"
        "ipp"
        "ffmpeg"
        "ffmpeg_motion"
	"ffmpeg_noise"
        "linux_battery"
        "esphome"
	"keenetic_ndms2"
        "mpd"
        "mjpeg"
        "mobile_app"
        "frontend"
        "history"
        "mqtt"
        "shelly"
        "stream"
        "xiaomi"
        "xiaomi_ble"
        "bluetooth"
	"nut"
	"rest"
        "xiaomi_miio"
      ];


     extraPackages = python3Packages: with python3Packages; [
       # aqara-gw-support
       paho-mqtt
     ];

    };

    # zigbee2mqtt = on // {
    # };

  };

}
