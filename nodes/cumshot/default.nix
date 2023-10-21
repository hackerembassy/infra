{ config, inputs, ... }: {

  imports = [
    "${inputs.self}/modules/home-manager"
    "${inputs.self}/modules/core.nix"
  ];

  networking.firewall.enable = false;
  networking.hostName = "cumshot";

}
