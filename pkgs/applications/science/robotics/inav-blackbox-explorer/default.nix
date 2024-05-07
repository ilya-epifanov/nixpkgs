{ lib
, stdenv
, fetchurl
, makeDesktopItem
, copyDesktopItems
, nwjs084
, wrapGAppsHook3
, gsettings-desktop-schemas
, gtk3
, nwjs-ffmpeg-prebuilt
}:

let
  nwjs = nwjs084;
in
stdenv.mkDerivation rec {
  pname = "inav-blackbox-explorer";
  binname = pname;
  version = "7.0.0";

  src = fetchurl {
    url = "https://github.com/iNavFlight/blackbox-log-viewer/releases/download/${version}/INAV-BlackboxExplorer_linux64_${version}.tar.gz";
    sha256 = "13fd3m6rzp3wwrqm11nx4a5m0jp9ck8k7167ymlwhsnjx74isp8v";
  };

  icon = fetchurl {
    url = "https://github.com/iNavFlight/blackbox-log-viewer/blob/${version}/images/inav_icon_128.png?raw=true";
    sha256 = "0yyp7ls4f9rh76dz7v122vf8jak9axnw3nximar9fwr2482paab4";
  };

  postUnpack = ''
    find -name "lib*.so" -delete
    find -name "lib*.so.*" -delete
  '';

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 ];

  buildInputs = [ gsettings-desktop-schemas gtk3 ];

  installPhase = let
    # due to the way we invoke nw, rpaths won't work properly
    ld_library_path = lib.makeLibraryPath [ nwjs-ffmpeg-prebuilt ];
  in ''
    runHook preInstall

    mkdir -p $out/bin \
            $out/opt/${pname}

    cp -r * $out/opt/${pname}/
    install -m 444 -D $icon $out/share/icons/hicolor/128x128/apps/${pname}.png

    chmod +x $out/opt/${pname}/${binname}
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} \
                --add-flags $out/opt/${pname} \
                --suffix LD_LIBRARY_PATH : ${ld_library_path}

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "INAV blackbox explorer";
    desktopName = "INAV blackbox explorer";
    genericName = "INAV blackbox explorer";
  };

  meta = with lib; {
    description = "The INAV blackbox explorer";
    mainProgram = "inav-blackbox-explorer";
    longDescription = ''
      This tool allows you to open logs recorded by INAV's Blackbox feature.
      You can seek through the log to examine graphed values at each timestep.
      If you have a flight video, you can load that in as well and it'll be played behind the log.
      You can export the graphs as a WebM video to share with others.
    '';
    homepage = "https://github.com/iNavFlight/blackbox-log-viewer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ilya-epifanov ];
    platforms = platforms.linux;
  };
}
