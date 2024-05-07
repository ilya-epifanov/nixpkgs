{ lib, stdenv, fetchurl, makeDesktopItem, copyDesktopItems, nwjs, wrapGAppsHook3, gsettings-desktop-schemas, gtk3, tree }:

stdenv.mkDerivation rec {
  pname = "frsky-osd";
  binname = "FrSkyOSD";
  version = "2.0.3";

  src = fetchurl {
    url = "https://github.com/FrSkyRC/FrSkyOSDApp/releases/download/v${version}/FrSky_OSD-linux-amd64-${version}.tar.gz";
    sha256 = "sha256-ExtTMTLbKmc6GnV1QSKo7Q+jExnz5cG1VvB4yIbahTE=";
  };

  sourceRoot = "usr/local";

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 tree ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R * $out

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "FrSky OSD configuration tool";
    desktopName = "FrSkyOSDApp";
    genericName = "FrSky OSD configuration tool";
  };

  meta = with lib; {
    description = "FrSkyOSDApp";
    mainProgram = "${binname}";
    longDescription = ''
      FrSky OSD configuration tool
    '';
    homepage = "https://github.com/FrSkyRC/FrSkyOSDApp";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ ilya-epifanov ];
    platforms = platforms.linux;
  };
}
