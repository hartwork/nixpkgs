{ stdenv, fetchurl, lib }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

let
  version = "2.4.1";
in stdenv.mkDerivation rec {
  name = "expat-${version}";

  src = fetchurl {
    url = "https://github.com/libexpat/libexpat/releases/download/R_${lib.replaceStrings ["."] ["_"] version}/${name}.tar.xz";
    sha256 = "sha256-zwMtDbqbkoY2VI4ysyei1msaq2PE9KE90TLC0dLy+2o=";
  };

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  configureFlags = lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true; # not cross;

  preCheck = ''
    patchShebangs ./run.sh
    patchShebangs ./test-driver-wrapper.sh
  '';

  meta = with lib; {
    homepage = "https://libexpat.github.io/";
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
