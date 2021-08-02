{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule rec {
  pname = "ghostunnel";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ghostunnel";
    repo = "ghostunnel";
    rev = "v${version}";
    sha256 = "sha256-EE8gCm/gOp3lmCx1q4PahulipLoBZnEatNAVUXzHIVw=";
  };

  vendorSha256 = "sha256-XgmvqB1PCfL2gSDqwqauSixk8vlINHRmX6U0h9EXXdU=";

  deleteVendor = true;

  # The certstore directory isn't recognized as a subpackage, but is when moved
  # into the vendor directory.
  postUnpack = ''
    mkdir -p $sourceRoot/vendor/ghostunnel
    mv $sourceRoot/certstore $sourceRoot/vendor/ghostunnel/
  '';

  meta = with lib; {
    description = "A simple TLS proxy with mutual authentication support for securing non-TLS backend applications";
    homepage = "https://github.com/ghostunnel/ghostunnel#readme";
    license = licenses.asl20;
    maintainers = with maintainers; [ roberth ];
  };

  passthru.tests.nixos = nixosTests.ghostunnel;
  passthru.tests.podman = nixosTests.podman-tls-ghostunnel;
}
