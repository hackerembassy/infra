{ config, inputs, lib, pkgs, currentSystem, ... }:
{

  nixpkgs.config.allowUnfree = true;

  services = {
    # caddy = {
    #   enable = true;
    #   virtualHosts = {
    #     "lore.hackem.cc" = {
    #       extraConfig = ''
    #         reverse_proxy 127.0.0.1:18989
    #       '';
    #     };
    #   };
    # };

    # cumshot is weird
    redis.servers.outline.logfile = "stdout";

    outline = {
      enable = true;
      publicUrl = "https://lore.hackem.cc";
      forceHttps = false;
      port = 18989;

      oidcAuthentication =

        let
          # oidcConf = with builtins; fromJSON (readFile "${inputs.self}/openid-configuration.json");
          oidcConf = with builtins; fromJSON (readFile "${inputs.self}/openid-configuration-a.hackem.cc.json");
        in
        {
          # clientId = "outline";
          # clientSecretFile = "/var/lib/outline/outline-oidc-secret";
          # scopes = [ "openid" "email" "profile" ];
          # usernameClaim = "preferred_username";
          # displayName = "Dex (GitHub)";

          clientId = "KBYllUE6Zezfo3CstIZYzdu72IZZUS5Zap9WVWGX";
          scopes = [ "openid" "email" "profile" ];
          usernameClaim = "preferred_username";
          clientSecretFile = "/var/lib/outline/outline-oidc-a-secret";
          displayName = "a.hackem.cc/authentik";

          authUrl = oidcConf.authorization_endpoint;
          tokenUrl = oidcConf.token_endpoint;
          userinfoUrl = oidcConf.userinfo_endpoint;
        };

      storage.storageType = "local";

    };

  };

  system.activationScripts = {
    cp-outline-secrets = ''
      cp /secrets/outline* /var/lib/outline
    '';
  };

}
