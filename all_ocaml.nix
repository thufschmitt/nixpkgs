{ nixpkgs ? ./. }:
with import nixpkgs { config = { allowBroken = true; }; };
# {
    lib.filterAttrs
        (_: val: val.src or null != null && !(val.meta.broken or false))
        ocamlPackages_4_03
  # ocaml_packages =
  #   buildEnv {
  #   name = "all_ocaml";
  #   paths = lib.mapAttrsToList (name: value: value) (lib.filterAttrs
  #       (_: val: val.src or null != null && !(val.meta.broken or false))
  #   ocamlPackages_4_03);
  #   };
# }
