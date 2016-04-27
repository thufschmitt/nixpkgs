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

  # In the Nix sandbox, the TERM variable is unset and stty does not
  # work. In such a case, ocp-build crashes due to a bug. The
  # ./fix-for-no-term.patch fixes this bug in the source code and hence
  # also in the final installed version of ocp-build. However, it does not
  # fix the bug in the precompiled bootstrap version of ocp-build that is
  # used during the compilation process. In order to bypass the bug until
  # it's also fixed upstream, we simply set TERM to some valid entry in the
  # terminfo database during the bootstrap.
  TERM = "xterm";

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
