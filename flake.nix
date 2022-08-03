# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let
      jobs = import ./pkgs/top-level/release.nix {
        nixpkgs = self;
        nixpkgsArgs = {
          config = {
            allowUnfree = false;
            inHydra = true;
            config.contentAddressedByDefault = true;
          };
        };
      };

      lib = import ./lib;

      forAllSystems = f: lib.genAttrs lib.systems.flakeExposed (system: f system);

      legacyPackages = forAllSystems (system: import ./. { inherit system; config.contentAddressedByDefault = true; });

    in
    {
      lib = lib.extend (final: prev: {

        nixos = import ./nixos/lib { lib = final; };

        nixosSystem = args:
          import ./nixos/lib/eval-config.nix (
            args // {
              modules = args.modules ++ [{
                system.nixos.versionSuffix =
                  ".${final.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")}.${self.shortRev or "dirty"}";
                system.nixos.revision = final.mkIf (self ? rev) self.rev;
              }];
            } // lib.optionalAttrs (! args?system) {
              # Allow system to be set modularly in nixpkgs.system.
              # We set it to null, to remove the "legacy" entrypoint's
              # non-hermetic default.
              system = null;
            }
          );
      });

      checks.x86_64-linux = {
        inherit (legacyPackages.x86_64-linux)
          gcc
          apacheHttpd
          cmake
          cryptsetup
          emacs
          gettext
          git
          imagemagick
          jdk
          linux
          mysql
          nginx
          nodejs
          openssh
          php
          postgresql
          python
          rsyslog
          stdenv
          subversion
          vim
          firefox
          libreoffice
          pandoc;
        myRev = legacyPackages.x86_64-linux.runCommand "my-rev" {} ''
          echo ${self.rev or "Unknown"} > $out
        '';
      };

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (import ./nixos/release-small.nix {
          nixpkgs = self;
        }).nixos.manual.x86_64-linux;
      };

      legacyPackages = legacyPackages;

      nixosModules = {
        notDetected = import ./nixos/modules/installer/scan/not-detected.nix;
      };
    };
}
