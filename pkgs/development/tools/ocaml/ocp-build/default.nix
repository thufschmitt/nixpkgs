{ stdenv, fetchFromGitHub, ocaml, findlib, ncurses, buildEnv }:
stdenv.mkDerivation rec {

  name = "ocp-build-${version}";
  version = "1.99.14-beta-without-camlp4";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-build";
    rev = "cf49428a2323021012e76e61b65fb1809de3fb1b";
    sha256 = "1s6cxnjfarqnk59glf5brcpi7qjapi360m1djl97vpjiywbgr0d2";
  };

  buildInputs = [ ocaml findlib ncurses ];
  preInstall = "mkdir -p $out/bin";

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
