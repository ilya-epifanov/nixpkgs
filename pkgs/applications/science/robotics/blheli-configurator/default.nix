{lib, stdenv, fetchurl, unzip, makeDesktopItem, nwjs084, wrapGAppsHook3, gsettings-desktop-schemas, gtk3 }:

let
  nwjs = nwjs084;
  pname = "blheli-configurator";
  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "BLHeli configuration tool";
    desktopName = "BLHeli Configurator";
    genericName = "BLHeli ESC configuration tool";
  };
in
stdenv.mkDerivation rec {
  inherit pname;
  version = "1.2.0";
  src = fetchurl {
    url = "https://github.com/blheli-configurator/blheli-configurator/releases/download/${version}/BLHeli-Configurator_linux64_${version}.zip";
    sha256 = "1lyyxjf2ql818m59l45nsa4pwqxgwfrlzsg7209r1n5g2f8h36va";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/blheli-configurator/blheli-configurator/1.2.0/images/icon_128.png";
    sha256 = "10miji4q2zlyql65nzq4f643x9b8z1bn9paf42vdpx1w0ma6100g";
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
             $out/opt/${pname}

    cp -r . $out/opt/${pname}/
    install -m 444 -D $icon $out/share/icons/hicolor/128x128/apps/${pname}.png
    cp -r ${desktopItem}/share/applications $out/share/

    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} --add-flags $out/opt/${pname}/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "An application for flashing and configuration of BLHeli firmware";
    mainProgram = "blheli-configurator";
    longDescription = ''
      An application for BLHeli firmware flashing and configuration.
    '';
    homepage    = "https://github.com/blheli-configurator/blheli-configurator";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license     = licenses.gpl3;
    maintainers = with maintainers; [ ilya-epifanov ];
    platforms   = platforms.linux;
  };
}
