{ config, inputs, ... }: {

  imports = [
    #./syncthing.nix
    ./hass.nix
    "${inputs.self}/modules/home-manager"
    "${inputs.self}/modules/core.nix"
    # "${inputs.self}/modules/sway/system.nix"
  ];

  networking.firewall.enable = false;
  networking.hostName = "jigglypuff";
  _.user = "user";

  home-manager.users.user = {
    imports = [
      # "${inputs.self}/modules/sway/core.nix"
    ];
    home.stateVersion = "22.05";
    home.keyboard = {
      layout = config.services.xserver.layout;
      options = with builtins;
        filter isString (split "," config.services.xserver.xkbOptions);
    };
  };

  users.users.user = {
    password = "12345";
    isNormalUser = true;
  };

  users.users.root.password = "12345";
  security.sudo.wheelNeedsPassword = false;

}
