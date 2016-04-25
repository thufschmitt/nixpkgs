{ stdenv, fetchFromGitHub, ocaml, findlib, ncurses, camlp4, buildEnv }:
let
  caml_with_p4 = buildEnv {
    name = "caml-with-camlp4";
    paths = [ ocaml camlp4 ];
  };
in
stdenv.mkDerivation rec {

  name = "ocp-build-${version}";
  version = "1.99.14-beta";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-build";
    rev = version;
    sha256 = "06zwga9w4nnyg2zf4l4870dss6jpnip9fk7b6dimij0id09w02dj";

    # url = http://www.typerex.org/pub/ocp-build/ocp-build.1.99.9-beta.tar.gz;
    # sha256 = "0wcb49bp239ns9mz55ky0kfjcz80cp97k0j0rwaw4h5sp3phn4l0";
  };

  buildInputs = [ caml_with_p4 findlib ncurses ];
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
