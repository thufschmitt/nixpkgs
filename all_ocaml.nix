{ nixpkgs ? ./., ocamlPath ? "ocamlPackages_4_03" }:
let pkgs = import nixpkgs { config = { allowBroken = true; }; }; in

with pkgs;
  lib.filterAttrs
    (_: val: val.src or null != null && !(val.meta.broken or false))
    pkgs."${ocamlPath}"
