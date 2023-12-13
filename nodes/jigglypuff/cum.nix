{ config, pkgs, inputs, ... }: {
  # vaapi stuffs
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver vaapiIntel ];
  };
  systemd.services.jigglycum = {
    script = "${pkgs.ustreamer}/bin/ustreamer -f 15 -s 0 -p 7000";
    enable = true;
    after = [ "network.target" ];
  };
}