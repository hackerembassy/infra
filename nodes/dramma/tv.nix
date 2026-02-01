{ pkgs, ... }: {
  services.cage = {
    enable = true;
    user = "tv";
    extraArguments = [ "-s" "-d" ];
    environment = {
      NIXOS_OZONE_WL = "1";
    };
    program = "${pkgs.chromium}/bin/chromium --enable-native-gpu-memory-buffers --ozone-platform-hint=auto --enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE --enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport --enable-features=UseMultiPlaneFormatForHardwareVideo --ignore-gpu-blocklist --enable-zero-copy --kiosk --autoplay-policy=no-user-gesture-required --noerrdialogs --enable-features=OverlayScrollbar --disable-restore-session-state --disable-infobars --no-first-run -app=https://ha.hackem.cc/phone-dash/0?BrowserID=inside-display";
  };
  systemd.services.cage-tty1.serviceConfig.Restart = "always";
}
