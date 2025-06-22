{ pkgs, ... }: {
  services.cage = {
    enable = true;
    user = "cab";
    extraArguments = [ "-s" "-d" ];
    program = "${pkgs.chromium}/bin/chromium http://127.0.0.1";
  };
  systemd.services.cage-tty1.serviceConfig.Restart = "always";
}
