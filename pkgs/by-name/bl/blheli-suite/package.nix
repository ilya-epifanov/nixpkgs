{ lib
, stdenv
, fetchurl
, makeDesktopItem
, copyDesktopItems
, wrapGAppsHook3
, gsettings-desktop-schemas
, gtk3
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

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 ];

  buildInputs = [ gsettings-desktop-schemas gtk3 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin \
            $out/opt/${pname}

    cp -r * $out/opt/${pname}/

    chmod +x $out/opt/${pname}/BLHeliSuite32xl

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
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
