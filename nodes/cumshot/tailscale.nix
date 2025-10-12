{ config, pkgs, prelude, ... }@args: with prelude args;
{
  services.tailscale.enable = true;
  systemd.services.headscale = {
    # It is dumb-ish
    serviceConfig.TimeoutStopSec = 10;
    environment = {
      HEADSCALE_EXPERIMENTAL_FEATURE_SSH = "1";
    };
  };
  
  services.headscale = let 
  in {
    enable = true;
    settings = {
      server_url = "https://tail.hackem.cc";
      listen_addr = "0.0.0.0:8888";
      ip_prefixes = [
        "100.64.0.0/16"
        "fd7a:115c:a1e0::/48"
      ];
      log.level = "info";
      policy.mode = "database";
      oidc = {
	client_id = "x6Ji5XAWjYIl93mA4YBGvTpPRKc8Aw53CxYq6FPo";
	client_secret_path = "/secrets/headscale-oidc-secret";
	#strip_email_domain = true;
	scope = [
	  "openid"
	  "profile"
	  "email"	
	];
	issuer = "https://a.hackem.cc/application/o/tailscale/";
      };
      dns = {
        magic_dns = true;
        nameservers.global = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
        base_domain = "xkem.am";
        search_domains = [
          "lan"
        ];
        nameservers.split = {
          "lan" = [
            "10.13.37.254"
          ];
        };
      };
    };
  };
}
