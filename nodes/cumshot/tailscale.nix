{ config, pkgs, prelude, ... }@args: with prelude args;
{
  services.tailscale.enable = true;
  systemd.services.headscale = {
    # It is dumb-ish
    serviceConfig.TimeoutStopSec = 2;
    environment = {
      HEADSCALE_EXPERIMENTAL_FEATURE_SSH = "1";
    };
  };
  
  services.headscale = let 
    aclFile = builtins.toFile "acl.json" acl;
    accept = src: dst: { action = "accept"; inherit src dst; }; 
    deny = src: dst: { action = "deny"; inherit src dst; }; 
    acl = builtins.toJSON {
        acls = [
          (accept ["*"] ["*:*"])
        ];
        ssh = [
          (accept ["*"] ["sys"] // {users = ["*"];}) 
          # (deny ["sys"] ["*"] // {users = ["*"];}) # IDK, it just denies *→sys as well :\
        ];
        autoApprovers = {
          exitNode = [ "*" ];
        };
    };  
  in {
    enable = true;
    settings = {
      server_url = "https://tail.hackem.cc";
      listen_addr = "0.0.0.0:8888";
      ip_prefixes = [
        "100.64.0.0/16"
        "fd7a:115c:a1e0::/48"
      ];
      log.level = "debug";
      acl_policy_path = aclFile;
      dns_config = {
        magic_dns = true;
        nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
        base_domain = "hackem";
        domains = [
          "lan"
        ];
        restricted_nameservers = {
          "lan" = [
            "192.168.1.1"
          ];
        };
      };
    };
  };
}