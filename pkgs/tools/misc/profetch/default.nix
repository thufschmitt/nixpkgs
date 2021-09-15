{ stdenv, lib, fetchFromGitHub, gprolog }:

stdenv.mkDerivation rec {
  pname = "profetch";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "RustemB";
    repo = pname;
    rev = "v${version}";
    sha256 = "1clh3l50wz6mlrw9kx0wh2bbhnz6bsksyh4ngz7givv4y3g9m702";
  };

  nativeBuildInputs = [ gprolog ];

  buildPhase = ''
    runHook preBuild
    gplc profetch.pl --no-top-level --no-debugger    \
                     --no-fd-lib    --no-fd-lib-warn \
                     --min-size -o profetch
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin profetch
    runHook postInstall
  '';

  meta = with lib; {
    description = "System Information Fetcher Written in GNU/Prolog";
    homepage = "https://github.com/RustemB/profetch";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.vel ];
  };
}
