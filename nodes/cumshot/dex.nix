{ pkgs, ... }: {

  # Probably to be upstreamed
  systemd.services.dex = {
    serviceConfig.StateDirectory = "dex";
  };

  services.dex = {

    # Something to be replaced by the «Serokellⓒ Vault™ SecurityHack™»
    environmentFile = "/secrets/dex-env";

    enable = true;
    settings = {
      issuer = "https://auth.hackem.cc";

      storage = {
        type = "sqlite3";
        config.file = "/var/lib/dex/db.sqlite3";
      };

      web = {
        http = "0.0.0.0:5556";
      };

      enablePasswordDB = true;
      staticClients = [
        # No clients yet, but they look about like that
        {
          id = "outline";
          name = "Outline Client";
          redirectURIs = [ "https://lore.hackem.cc/auth/oidc.callback" ];
          secretFile = "/var/lib/dex/outline-oidc-secret";
        }
      ];

      connectors = [
        {
          id = "github-hackem";
          type = "github";
          name = "GitHub | Hacker Embassy";

          config = {
            redirectURI = "https://auth.hackem.cc/callback";
            clientID = "$GITHUB_CLIENT_ID";
            clientSecret = "$GITHUB_CLIENT_SECRET";
            teamNameField = "slug";
            orgs = [
              { name = "hackerembassy"; teams = [ "members" ]; }
            ];
          };

        }
      ];
    };

  };

  # You will need to either puncutre a hole in systemd containment, or drop it in a state directory — I prefer latter.
  system.activationScripts = {
    cp-dex-secrets = ''
      cp /secrets/outline-oidc-secret /var/lib/dex
    '';
  };
}