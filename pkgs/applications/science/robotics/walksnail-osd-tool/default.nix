{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, wrapGAppsHook3
, makeDesktopItem
, copyDesktopItems
, rustPlatform
, cargo
, cmake
, pkg-config
, libGL
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "walksnail-osd-tool";
  version = "v0.3.0"; # don't forget to update the make-build-reproducible.patch

  src = fetchFromGitHub {
    owner = "avsaase";
    repo = pname;
    rev = "1044026bab773386fe96e20b544f60ad73d24e3f";
    hash = "sha256-xCrshFRsM4qUF4TffZiriNaplkjif/LeFOwLxoqtwsY=";
  };

  patches = [
    ./make-build-reproducible.patch
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ffprobe-0.3.3" = "sha256-T6ht3ZS68Hsfw+t9uGO+ZveZJtvEH3nCd+N3vh8g5HM=";
      "poll-promise-0.2.0" = "sha256-IrV0asFTu2P/FW60ft0PphFzfmkR08M/YBwUXuGVRXk=";
    };
  };

  nativeBuildInputs = [ 
    cargo
    cmake
    copyDesktopItems
    openssl.dev
    pkg-config
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
  ];
  buildInputs = [
    openssl
  ];
  OPENSSL_NO_VENDOR = 1;

  postFixup = let
    rpath = lib.makeLibraryPath [ libGL ];
  in ''
    patchelf --add-rpath ${rpath} $out/bin/.${pname}-wrapped
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "Walksnail OSD Tool";
    desktopName = "Walksnail OSD Tool";
    genericName = "Walksnail OSD Tool";
  };

  meta = with lib; {
    description = "Cross-platform tool for rendering the flight controller OSD and SRT data from the Walksnail Avatar HD FPV system on top of the goggle or VRX recording";
    homepage = "https://github.com/avsaase/walksnail-osd-tool";
    license = licenses.mit;
    maintainers = with maintainers; [ ilya-epifanov ];
    platforms = platforms.linux;
    mainProgram = "walksnail-osd-tool";
  };
}
