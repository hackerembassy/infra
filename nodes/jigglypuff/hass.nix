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
	"tts"
	"media_player"
        "media_source"
	"google_translate"
	"homekit_controller"
	"apple_tv"
	"lifx"
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
	"wyoming"
      ];


     extraPackages = python3Packages: with python3Packages; [
       # aqara-gw-support
       paho-mqtt
     ];

    };

    zigbee2mqtt = on // {
      settings = {
        homeassistant = config.services.home-assistant.enable;
	frontend = {
	  auth_token = "!secrets.yaml auth_token";
	};
        mqtt = {
	  server = "!secrets.yaml host";
	  user = "!secrets.yaml user";
	  password = "!secrets.yaml pass";
        };
	serial = {
	  port = "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_4c1f564c8bc9eb11a2cf8d4f1d69213e-if00-port0";
	};
	advanced = {
	  network_key = "!secrets.yaml netkey";
	};};
    };

  };

}
