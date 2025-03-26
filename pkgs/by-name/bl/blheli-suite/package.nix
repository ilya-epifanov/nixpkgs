{ lib
, stdenv
, fetchurl
, unzip
, makeDesktopItem
, copyDesktopItems
, wrapGAppsHook3
, gsettings-desktop-schemas
, gtk3
, glib
, curl
}:

stdenv.mkDerivation rec {
  pname = "blheli-suite";
  version = "10.0.0";

  src = fetchurl {
    url = "https://github.com/bitdump/BLHeli/releases/download/Rev32.10/BLHeliSuite32xLinux64_1044.zip";
    hash = "sha256-Fi/rMQz02/2QVTY32Q16DcJPWmeVcx+EjcN+meBxt14=";
  };

  # postUnpack = ''
  #   find -name "lib*.so" -delete
  #   find -name "lib*.so.*" -delete
  # '';

  nativeBuildInputs = [ copyDesktopItems unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin \
             $out/opt/${pname}

    cp -r * $out/opt/${pname}/

    chmod +x $out/opt/${pname}/BLHeliSuite32xl
    ln -s $out/opt/${pname}/BLHeliSuite32xl $out/bin/BLHeliSuite32xl

    runHook postInstall
  '';

  postFixup = let
    rpath = lib.makeLibraryPath [ gtk3 glib curl ];
  in ''
    patchelf $out/opt/${pname}/BLHeliSuite32xl --add-rpath ${rpath}
  '';

  desktopItems = makeDesktopItem {
    name = "BLHeliSuite32";
    exec = "BLHeliSuite32xl";
    comment = "BLHeliSuite32";
    desktopName = "BLHeliSuite32";
    genericName = "BLHeliSuite32";
  };

  meta = {
    description = "BLHeli32 ESC configurator";
    mainProgram = "BLHeliSuite32xl";
    homepage = "https://github.com/bitdump/BLHeli";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.gpl3Only; # closed source
    maintainers = with lib.maintainers; [ ilya-epifanov ];
    platforms = [ "x86_64-linux" ];
  };
}
