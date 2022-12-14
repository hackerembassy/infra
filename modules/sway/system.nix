{ config, pkgs, lib, inputs, prelude, ... }@args:
with prelude args; {

  require = [ ../desktop.nix ];

  users.users.${config._.user}.extraGroups = [ "input" ];

  fonts = {
    enableDefaultFonts = true;

    fontconfig = on // {
      defaultFonts = {
        monospace = ["Fira Mono"];
      };
    };

    fonts = with pkgs; [
      source-code-pro noto-fonts
      roboto fira-code fira
      font-awesome
      orbitron
    ];

  };

  services = {
    gvfs = on;
    gnome = {
      glib-networking = on;
      gnome-online-accounts = on;
      gnome-online-miners = on;
      sushi = on;
    };
  };

  # That adds /etc/sway/config.d/nixos.conf with one important line.
  # Yeah, I'm too lazy to copy it here.
  # also it enables whole bunch of other options, which I am too lazy to describe here.
  # just look at <nixpkgs/nixos/modules/programs/sway.nix>
  programs.sway = on;

  # That makes screensharing possible
  xdg = {
    portal = {
     extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
     wlr = on // {
       settings.screencast = {
         chooser_type = "dmenu";
         chooser_cmd = "${pkgs.rofi-wayland}/bin/rofi -dmenu";
       };
     };
      #gtkUsePortal = true;
    };
  };

}
