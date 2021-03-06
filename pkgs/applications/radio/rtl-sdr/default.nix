{ lib, stdenv, fetchgit, fetchpatch, cmake, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  pname = "rtl-sdr";
  version = "0.6.0";

  src = fetchgit {
    url = "git://git.osmocom.org/rtl-sdr.git";
    rev = "refs/tags/${version}";
    sha256 = "0lmvsnb4xw4hmz6zs0z5ilsah5hjz29g1s0050n59fllskqr3b8k";
  };

  patches = [ (fetchpatch {
    name = "hardened-udev-rules.patch";
    url = "https://osmocom.org/projects/rtl-sdr/repository/revisions/b2814731563be4d5a0a68554ece6454a2c63af12/diff?format=diff";
    sha256 = "0ns740s2rys4glq4la4bh0sxfv1mn61yfjns2yllhx70rsb2fqrn";
  }) ];

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ libusb1 ];

  # TODO: get these fixes upstream:
  # * Building with -DINSTALL_UDEV_RULES=ON tries to install udev rules to
  #   /etc/udev/rules.d/, and there is no option to install elsewhere. So install
  #   rules manually.
  # * Propagate libusb-1.0 dependency in pkg-config file.
  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/etc/udev/rules.d/"
    cp ../rtl-sdr.rules "$out/etc/udev/rules.d/99-rtl-sdr.rules"

    pcfile="$out"/lib/pkgconfig/librtlsdr.pc
    grep -q "Requires:" "$pcfile" && { echo "Upstream has added 'Requires:' in $(basename "$pcfile"); update nix expression."; exit 1; }
    echo "Requires: libusb-1.0" >> "$pcfile"
  '';

  meta = with lib; {
    description = "Turns your Realtek RTL2832 based DVB dongle into a SDR receiver";
    homepage = "http://sdr.osmocom.org/trac/wiki/rtl-sdr";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
