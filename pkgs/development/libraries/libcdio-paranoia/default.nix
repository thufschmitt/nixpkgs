{ fetchurl, stdenv, libcddb, pkgconfig, ncurses, help2man, libcdio }:

stdenv.mkDerivation rec {
  name = "libcdio-paranoia-10.2+0.93+1";

  src = fetchurl {
    url = "mirror://gnu/libcdio/${name}.tar.bz2";
    sha256 = "14x4b4jk5b0zvcalrg02y4jmbkmmlb07qfmk5hph9k18b8frn7gc";
  };

  buildInputs = [ libcddb pkgconfig ncurses help2man ];
  propagatedBuildInputs = [ libcdio ];

  meta = {
    description = "CD paranoia libraries from GNU libcdio";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.gnu.org/software/libcdio/;
    platforms = stdenv.lib.platforms.linux;
  };
}
