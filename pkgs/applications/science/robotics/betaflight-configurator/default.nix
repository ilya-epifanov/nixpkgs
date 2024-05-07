{lib, stdenv, fetchurl, unzip, makeDesktopItem, nwjs084, wrapGAppsHook3, gsettings-desktop-schemas, gtk3, version, sha256 }:

stdenv.mkDerivation rec {
  pname = "betaflight-configurator";
  inherit version;
  shortVersion = lib.versions.majorMinor version;
  pname_versioned = pname + "." + shortVersion;

  src = fetchurl {
    url = "https://github.com/betaflight/${pname}/releases/download/${version}/${pname}_${version}_linux64-portable.zip";
    inherit sha256;
  };

  # remove large unneeded files
  postUnpack = ''
    find -name "lib*.so" -delete
    find -name "lib*.so.*" -delete
  '';

  nativeBuildInputs = [ wrapGAppsHook3 unzip ];

  buildInputs = [ gsettings-desktop-schemas gtk3 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin \
             $out/opt/${pname_versioned}

    cp -r . $out/opt/${pname_versioned}/
    install -m 444 -D icon/bf_icon_128.png $out/share/icons/hicolor/128x128/apps/${pname_versioned}.png
    cp -r ${desktopItem}/share/applications $out/share/

    makeWrapper ${nwjs084}/bin/nw $out/bin/${pname_versioned} --add-flags $out/opt/${pname_versioned}
    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = pname_versioned;
    exec = pname_versioned;
    icon = pname_versioned;
    comment = "Betaflight configuration tool " + version;
    desktopName = "Betaflight Configurator " + version;
    genericName = "Flight controller configuration tool";
  };
  meta = with lib; {
    description = "The Betaflight flight control system configuration tool";
    mainProgram = pname_versioned;
    longDescription = ''
      A crossplatform configuration tool for the Betaflight flight control system.
      Various types of aircraft are supported by the tool and by Betaflight, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage    = "https://github.com/betaflight/betaflight/wiki";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license     = licenses.gpl3;
    maintainers = with maintainers; [ wucke13 ilya-epifanov ];
    platforms   = platforms.linux;
  };
}
