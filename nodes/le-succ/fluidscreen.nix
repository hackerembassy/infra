{ pkgs, ... }: {
  services.cage = {
    enable = true;
    user = "tv";
    extraArguments = [ "-s" "-d" ];
    program = "${pkgs.chromium}/bin/chromium --kiosk --noerrdialogs --disable-restore-session-state --disable-infobars --no-first-run http://127.0.0.1";
  };
  systemd.services.cage-tty1.serviceConfig.Restart = "always";
}
