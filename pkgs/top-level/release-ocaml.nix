{ nixpkgs ? { outPath = (import ../.. {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" ]
, ocamlPath ? "ocamlPackages_4_03"
}:

with import ../../lib;
with import ./release-lib.nix {inherit supportedSystems; };

let
  ocamlPackages = mapAttrs (_: value:
    let res = builtins.tryEval (
    if isDerivation value && !(value.meta.broken or false) then
        value.meta.platforms or [ platforms.linux ] else []);
    in if res.success then res.value else [])
    pkgs."${ocamlPath}";
in (mapTestOn ocamlPackages)
