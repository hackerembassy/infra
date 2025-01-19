{
  services.firefly-iii = {
    enable = true;
    virtualHost = "0.0.0.0:23000";
    settings = {
      APP_URL = "https://gold.hackem.cc";
      APP_ENV = "production";
      APP_KEY_FILE = "/secrets/firefly-app-key";
    };
  };
  # system.activationScripts = {
  #   cp-dex-secrets = ''
  #     cp /secrets/firefly* /var/lib/firefly-iii
  #   '';
  # };
}