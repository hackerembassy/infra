{ config, pkgs, prelude, ... }@args: with prelude args;
{
  hardware.bluetooth.enable = true;
  services = {
    avahi = on;

    home-assistant = on // {
      configWritable = true;
      openFirewall = true;
      lovelaceConfigWritable = true;
      config = {
        default_config = {};
        homeassistant = {
          name = "Hacker Embassy";
          unit_system = "metric";
          time_zone = "Asia/Yerevan";
        };
        #binary_sensor = [
        #  { platform = "ffmpeg_motion"; input = "/dev/video2";  }
        #];
        sensor = [
          { platform = "linux_battery"; }
        ];
        ffmpeg = {

        };

        http = { };
      };

      extraComponents = [
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
      ];


    };

    # zigbee2mqtt = on // {
    # };

  };

}
