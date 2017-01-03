{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "simp_le-2016-12-16";

  # kuba/simp_le seems unmaintained
  src = fetchFromGitHub {
    owner = "zenhack";
    repo = "simp_le";
    rev = "63a43b8547cd9fbc87db6bcd9497c6e37f73abef";
    sha256 = "04dr8lvcpi797722lsy06nxhlihrxdqgdy187pg3hl1ki2iq3ixx";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/kuba/simp_le/commit/4bc788fdd611c4118c3f86b5f546779723aca5a7.patch";
      sha256 = "0036p11qn3plydv5s5z6i28r6ihy1ipjl0y8la0izpkiq273byfc";
    })
    (fetchpatch {
      url = "https://github.com/kuba/simp_le/commit/9ec7efe593cadb46348dc6924c1e6a31f0f9e636.patch";
      sha256 = "0n3m94n14y9c42185ly47d061g6awc8vb8xs9abffaigxv59k06j";
    })
  ];

  propagatedBuildInputs = with pythonPackages; [ acme ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner nckx ];
    platforms = platforms.all;
  };
}
