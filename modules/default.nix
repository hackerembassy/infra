{ pkgs, lib, ... }:
with lib;
{
  require = [ ./options.nix ./barecore.nix ];

}
