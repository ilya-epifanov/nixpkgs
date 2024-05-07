{ lib, stdenv, fetchurl, makeDesktopItem, copyDesktopItems, nwjs, wrapGAppsHook3, gsettings-desktop-schemas, gtk3, libGL, version, sha256 }:

stdenv.mkDerivation rec {
  pname = "inav-configurator";
  inherit version;
  shortVersion = lib.versions.major version;
  pname_versioned = pname + "." + shortVersion;

  src = fetchurl {
    url = "https://github.com/iNavFlight/inav-configurator/releases/download/${version}/INAV-Configurator_linux64_${version}.tar.gz";
    inherit sha256;
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/iNavFlight/inav-configurator/bf3fc89e6df51ecb83a386cd000eebf16859879e/images/inav_icon_128.png";
    sha256 = "1i844dzzc5s5cr4vfpi6k2kdn8jiqq2n6c0fjqvsp4wdidwjahzw";
  };

  postUnpack = ''
    find -name "lib*.so" -delete
    find -name "lib*.so.*" -delete
  '';

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 ];

  buildInputs = [ gsettings-desktop-schemas gtk3 ];

  installPhase = let
    # due to the way we invoke nw, rpaths won't work properly
    ld_library_path = lib.makeLibraryPath [ libGL ];
  in ''
    runHook preInstall

    mkdir -p $out/bin \
             $out/opt/${pname_versioned}

    cp -r * $out/opt/${pname_versioned}/
    # cp -r manifest.json main.html $out/opt/${pname_versioned}/
    install -m 444 -D $icon $out/share/icons/hicolor/128x128/apps/${pname_versioned}.png

    chmod +x $out/opt/${pname_versioned}/inav-configurator
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname_versioned} \
                --add-flags $out/opt/${pname_versioned} \
                --suffix LD_LIBRARY_PATH : ${ld_library_path}

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = pname_versioned;
    exec = pname_versioned;
    icon = pname_versioned;
    comment = "INAV configuration tool " + version;
    desktopName = "INAV Configurator " + version;
    genericName = "Flight controller configuration tool";
  };

  meta = with lib; {
    description = "The INAV flight control system configuration tool";
    mainProgram = pname_versioned;
    longDescription = ''
      A crossplatform configuration tool for the INAV flight control system.
      Various types of aircraft are supported by the tool and by INAV, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage = "https://github.com/iNavFlight/inav/wiki";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tilcreator wucke13 ilya-epifanov ];
    platforms = platforms.linux;
  };
}
