{
  description = "«simple» deploy-rs + terraform config";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    terranix.url = "github:terranix/terranix";

    rpi-nix.url = "github:nix-community/raspberry-pi-nix";
    # rpi-nix.inputs.nixpkgs.follows = "nixpkgs";

    printit.url = "github:adipierro/printit/nix";
    printit.inputs.nixpkgs.follows = "nixpkgs";

    printer-anette = {
      url = "github:hackerembassy/printer-anette";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs@{ self, nixpkgs, terranix, home-manager, ... }:
    with builtins; let
      nixpkgsPatches = [
        # (builtins.fetchurl {
        #   url = "https://github.com/NixOS/nixpkgs/pull/188273.diff";
        #   sha256 = "10i8lzlldfjab773bbzscsxsa4mbb0jyvhzrcp0kmlwzc4wnwnbb";
        # })
        # ./klipper.diff
        # ./moonraker.diff
      ];

      nixpkgsPatched = mapAttrs (sys: { applyPatches, ... }:
        let
          patchedSource = applyPatches {
            patches = nixpkgsPatches;
            name = "nixpkgs-patched";
            src = nixpkgs;
          };
          self = (import "${patchedSource}/flake.nix").outputs { inherit self; };
        in if nixpkgsPatches == [] then nixpkgs else self
      ) nixpkgs.legacyPackages;

      nixpkgs' =
        mapAttrs
          (prop: archset:
            if isAttrs archset && (prop != "lib")
              then
                (mapAttrs
                  (arch: _whatever: nixpkgsPatched.${arch}.${prop}.${arch})
                  archset
                )
              else
                archset
          )
          nixpkgs;

      shellSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      # Functions to filter out pkgs.
      # Technically should be provided by `flake-utils`, but it's nicer to vendor some of that stuff.
      foldAttrs =  foldl' (a: b: a // b) {};
      systemPkgs = nixpkgs'.legacyPackages;
      shellPkgs = peekAttrset systemPkgs shellSystems;
      peekAttrset = attrs: names: foldAttrs (map (n: { ${n} = attrs.${n}; }) names);
      onPkgs = f: mapAttrs f systemPkgs;
      onShellPkgs = f: mapAttrs f shellPkgs;

      # Functions to build system configurations
      inherit (nixpkgs') lib;
      specialArgs = { inherit inputs; prelude = import common/prelude.nix; };
      buildConfig = system: modules: { inherit modules system specialArgs; };
      buildSystem = system: modules:
        nixpkgsPatched.${system}.lib.nixosSystem (buildConfig system modules);

      # Maps over ./nodes directory, reading all of the configs there.
      hosts = attrNames (readDir ./nodes);
      nodes = with builtins; listToAttrs (map (a: {name = a; value = ./nodes/${a}; }) hosts);

      hostAttrs = nodepath: {
        settings = import (nodepath + "/host-metadata.nix");
        config = import (nodepath + "/configuration.nix");
        hw-config = import (nodepath + "/hardware-configuration.nix");
      };

      toNode = nodename: with (hostAttrs nodes.${nodename}); buildSystem settings.arch [
        config
        ({lib, ...}: { networking.hostName = nodename; })
        ./common/configuration.nix
        hw-config
      ];

      toVM = hostname: with (hostAttrs hostname); (buildSystem settings.arch [
        config
        ({lib, ...}: { networking.hostName = hostname; })
        ./common/configuration.nix
        (nixpkgs' + /nixos/modules/virtualisation/build-vm.nix)
      ]).config.system.build.vm;

    in
    {

      inherit nixpkgs' nixpkgsPatched;

      packages = onShellPkgs (system: pkgs: {
        terraform-config = terranix.lib.terranixConfiguration {
          inherit system;
          modules = [ ./terraform ];
        };
      } // foldAttrs (map (hostname: { ${hostname} = toVM hostname; }) hosts));

      devShells = onShellPkgs (system: pkgs: {
        default = with pkgs;
          mkShell {
            nativeBuildInputs = [
              # Nix formatter
              nixpkgs-fmt
              nil
              nushell
              gnumake
            ];
          };
      });

      nixosConfigurations = mapAttrs (nodename: _: toNode nodename) nodes;

      nodeMeta = builtins.mapAttrs  (_: h: (hostAttrs h)) nodes;
    };
}
