{ config, pkgs, inputs, ... }: {
  # vaapi stuffs
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver vaapiIntel ];
  };

  services.go2rtc = {
    enable = true;
    settings = {
      streams = {
        cam = "ffmpeg:device?video=/dev/video0&input_format=yuyv422&video_size=640x480#video=h264#hardware=vaapi";
      };
      ffmpeg.bin = "${pkgs.ffmpeg_6-full}/bin/ffmpeg";
    };
  };

}