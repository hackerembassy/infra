{ config, pkgs, ... }:

{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.root = {
    password = "12345";
  };

  users.users.keimoger = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
    ];
  };

  users.users.netbug = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      "mc"
    ];
  };
}
