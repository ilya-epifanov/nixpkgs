{ lib
, fetchFromGitHub
, makeWrapper
, rustPlatform
, cmake
, pkgconf
, freetype
, expat
, wayland
, xorg
, libxkbcommon
, pop-launcher
}:

rustPlatform.buildRustPackage rec {
  pname = "onagre";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "onagre-launcher";
    repo = pname;
    rev = "a02e725";
    hash = "sha256-CbDdRv1HAYrntS5gwzsHNpbx+6xRHeIz9gtAs96thqU=";
  };

  cargoSha256 = "sha256-f65KN9kMeYu0vgUxGT0Qc57Lwpvfw/Ga+4WOwjVUov4=";

  nativeBuildInputs = [ makeWrapper cmake pkgconf ];
  buildInputs = [ freetype expat
    libxkbcommon
    wayland
    xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi
    vulkan-loader libglvnd
  ];

  postFixup = let
    rpath = lib.makeLibraryPath buildInputs;
  in ''
    patchelf --set-rpath ${rpath} $out/bin/onagre
    wrapProgram $out/bin/onagre \
      --prefix PATH ':' ${lib.makeBinPath [
        pop-launcher
      ]}
  '';

  meta = with lib; {
    description = "A general purpose application launcher for X and wayland inspired by rofi/wofi and alfred";
    homepage = "https://github.com/onagre-launcher/onagre";
    license = licenses.mit;
    maintainers = [ maintainers.jfvillablanca ];
    platforms = platforms.linux;
    mainProgram = "onagre";
  };
}
