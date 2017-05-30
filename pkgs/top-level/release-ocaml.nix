/*
   test for example like this
   $ hydra-eval-jobs pkgs/top-level/release-python.nix
*/

{ nixpkgs ? { outPath = (import ../../lib).cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" ]
}:

with import ./release-lib.nix {inherit supportedSystems; };
with lib;

let
  onlyOcaml = mapAttrs (name: value:
    let res = builtins.tryEval (
      if hasPrefix "ocamlPackages" name then
        packagePlatforms value
      else []
    );
    in if res.success then res.value else []
    );
in (mapTestOn (onlyOcaml pkgs))

