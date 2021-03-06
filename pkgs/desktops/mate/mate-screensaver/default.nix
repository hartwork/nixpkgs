{ lib, stdenv, fetchurl, pkgconfig, gettext, gtk3, dbus-glib, libXScrnSaver, libnotify, libxml2, pam, systemd, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-screensaver";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0imb1z2yvz1h95dzq396c569kkxys9mb2dyc6qxxxcnc5w02a2dw";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    libxml2 # provides xmllint
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus-glib
    libXScrnSaver
    libnotify
    pam
    systemd
    mate.mate-desktop
    mate.mate-menus
  ];

  configureFlags = [ "--without-console-kit" ];

  makeFlags = [ "DBUS_SESSION_SERVICE_DIR=$(out)/etc" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Screen saver and locker for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
