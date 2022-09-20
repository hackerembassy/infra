{
  description = "«simple» deploy-rs + terraform config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    terranix.url = "github:terranix/terranix";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs@{ self, nixpkgs, terranix, deploy-rs, home-manager }:
    with builtins; let
      nixpkgsPatches = [
        (builtins.fetchurl {
          url = "https://github.com/NixOS/nixpkgs/pull/188273.diff";
          sha256 = "03jjafnyvcd4kncg1hsc7chivd542l0s6jv6q9sfrrjf19ab3wba";
        })
      ];

      nixpkgsPatched = mapAttrs (sys: { applyPatches, ... }:
        let
          patchedSource = applyPatches {
            patches = nixpkgsPatches;
            name = "nixpkgs-patched";
            src = nixpkgs;
          };
          self = (import "${patchedSource}/flake.nix").outputs { inherit self; };
        in self
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

      shellSystems = attrNames deploy-rs.packages;
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
        lib.nixosSystem (buildConfig system modules);
      deployNixos = s: deploy-rs.lib.${s.pkgs.system}.activate.nixos s;
      deployHomeManager = sys: s: deploy-rs.lib.${sys}.activate.home-manager s;

      # Maps over ./nodes directory, reading all of the configs there.
      hosts = attrNames (readDir ./nodes);
      hostAttrs = hostname: {
        settings = import ./nodes/${hostname}/host-metadata.nix;
        config = import ./nodes/${hostname}/configuration.nix;
        hw-config = import ./nodes/${hostname}/hardware-configuration.nix;
      };

      toNode = hostname: with (hostAttrs hostname); buildSystem settings.arch [
        config
        ({lib, ...}: { networking.hostName = hostname; })
        ./common/configuration.nix
        hw-config
      ];

      toVM = hostname: with (hostAttrs hostname); (buildSystem settings.arch [
        config
        ({lib, ...}: { networking.hostName = hostname; })
        ./common/configuration.nix
        (nixpkgs' + /nixos/modules/virtualisation/build-vm.nix)
      ]).config.system.build.vm;

      toDeployRsHost = hostname: with (hostAttrs hostname); {
        hostname = settings.hostname;
        profiles.system = { path = deployNixos (toNode hostname); user = "root"; };
      };

    in
    {

      inherit nixpkgs';

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
              # Nix config deployment utility
              deploy-rs.packages.${system}.default
              # Terraform
              terraform
              gnumake
            ];
          };
      });

      nixosConfigurations = with builtins; foldAttrs (map (hostname: {${hostname} = toNode hostname; }) hosts);

      deploy = {
        sshUser = "root";
        nodes = with builtins; foldAttrs (map (hostname: {${hostname} = toDeployRsHost hostname; }) hosts);
      };

    };
}
