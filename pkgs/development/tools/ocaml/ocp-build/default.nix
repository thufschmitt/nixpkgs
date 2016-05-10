{ stdenv, fetchFromGitHub, ocaml, findlib, ncurses, buildEnv, buildOcaml }:
let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in
buildOcaml rec {

  name = "ocp-build-${version}";
  version = "1.99.14-beta-without-camlp4";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-build";
    rev = "4bd408";
    sha256 = "132fdhx68yr2xf78paljvqkn0g3s9hbdzf03h70xk6spwq7xabym";
  };

  buildInputs = [ ocaml ];
  propagatedBuildInputs = [ ncurses ];
  preInstall = "mkdir -p $out/bin";
  preConfigure = ''
  echo $OCAMLFIND_DESTDIR
  export configureFlags="$configureFlags --with-metadir=$OCAMLFIND_DESTDIR"
  '';

  postInstall =
  ''
  mv $out/lib/META.* $OCAMLFIND_DESTDIR/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.typerex.org/ocp-build.html;
    description = "A build tool for OCaml";
    longDescription = ''
      ocp-build is a build system for OCaml application, based on simple
      descriptions of packages. ocp-build combines the descriptions of
      packages, and optimize the parallel compilation of files depending on
      the number of cores and the automatically-inferred dependencies
      between source files.
    '';
    license = licenses.gpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
