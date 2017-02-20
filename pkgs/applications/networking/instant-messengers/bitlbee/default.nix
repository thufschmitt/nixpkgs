{ fetchurl, fetchpatch, stdenv, gnutls, glib, pkgconfig, check, libotr, python,
enableLibPurple ? false, pidgin ? null }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-3.5";

  src = fetchurl {
    url = "mirror://bitlbee/src/${name}.tar.gz";
    sha256 = "06c371bjly38yrkvfwdh5rjfx9xfl7bszyhrlbldy0xk38c057al";
  };

  nativeBuildInputs = [ pkgconfig ] ++ optional doCheck check;

  buildInputs = [ gnutls glib libotr python ]
    ++ optional enableLibPurple pidgin;

  preConfigure = optionalString enableLibPurple
    "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${pidgin}/lib/pkgconfig";

  configureFlags = [
    "--gcov=1"
    "--otr=1"
    "--ssl=gnutls"
    "--pidfile=/var/lib/bitlbee/bitlbee.pid"
  ]
  ++ optional enableLibPurple "--purple=1";

  doCheck = !enableLibPurple; # Checks fail with libpurple for sme reason

  meta = {
    description = "IRC instant messaging gateway";

    longDescription = ''
      BitlBee brings IM (instant messaging) to IRC clients.  It's a
      great solution for people who have an IRC client running all the
      time and don't want to run an additional MSN/AIM/whatever
      client.

      BitlBee currently supports the following IM networks/protocols:
      XMPP/Jabber (including Google Talk), MSN Messenger, Yahoo!
      Messenger, AIM and ICQ.
    '';

    homepage = http://www.bitlbee.org/;
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ wkennington pSub ];
    platforms = platforms.gnu;  # arbitrary choice
  };
}
