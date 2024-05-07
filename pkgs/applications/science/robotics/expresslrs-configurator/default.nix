{ lib
, stdenv
, fetchurl
, makeDesktopItem
, copyDesktopItems
, nwjs084
, nwjs-ffmpeg-prebuilt
, wrapGAppsHook3
, gsettings-desktop-schemas
, gtk3
, unzip
, python311
, xorg
, libnotify
, git
, glib
, nss
, nspr
, expat
, libGL
}:

let
  nwjs = nwjs084;
in stdenv.mkDerivation rec {
  pname = "expresslrs-configurator";
  binname = "expresslrs-configurator";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/ExpressLRS/ExpressLRS-Configurator/releases/download/v${version}/expresslrs-configurator-${version}.zip";
    sha256 = "0b2ygxqyyah77i48n9xr559rrinzh1a5z81ll6mbc5v6nys47njz";
  };

  sourceRoot = ".";

  # postUnpack = ''
  #   find -name "lib*.so" -delete
  #   find -name "lib*.so.*" -delete
  # '';

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/ExpressLRS/ExpressLRS-Configurator/master/assets/icon.png";
    sha256 = "18bilv4r18jpps90gri058sa167i5dcmv578ywx9ym7w3zhnbkbd";
  };

  manifest = fetchurl {
    url = "https://raw.githubusercontent.com/ExpressLRS/ExpressLRS-Configurator/v${version}/package.json";
    sha256 = "07sa43m62fc6j4fgz20xsnjvmr8cfrmcdfqisf1x7d15ryxakrgq";
  };

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 unzip ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
    python311
    xorg.libXtst
    libnotify
    git
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin \
            $out/opt/${pname}

    cp -r * $out/opt/${pname}/
    cp $manifest $out/opt/${pname}/package.json

    install -m 444 -D $icon $out/share/icons/hicolor/128x128/apps/${pname}.png

    chmod +x $out/opt/${pname}/${binname}
    runHook postInstall
  '';

  postFixup = let
    path = lib.makeBinPath [ git python311 ];
    rpath = lib.makeLibraryPath [
      glib
      nss
      nspr
      gtk3
      expat
      libGL
      nwjs-ffmpeg-prebuilt
    ];
  in ''
    patchelf --add-rpath ${rpath} $out/opt/${pname}/${binname}
    makeWrapper $out/opt/${pname}/${binname} $out/bin/${pname} \
                --suffix PATH : ${path}
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "ExpressLRS configuration tool";
    desktopName = "ExpressLRS Configurator";
    genericName = "ExpressLRS configuration tool";
  };

  meta = with lib; {
    description = "ExpressLRS Configurator";
    mainProgram = "expresslrs-configurator";
    longDescription = ''
      ExpressLRS Configurator is a cross-platform build & configuration tool for the ExpressLRS
      - open source RC link for RC applications.
    '';
    homepage = "https://www.expresslrs.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ilya-epifanov ];
    platforms = platforms.linux;
  };
}
