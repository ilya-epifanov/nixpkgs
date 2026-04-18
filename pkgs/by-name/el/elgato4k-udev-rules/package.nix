{
  lib,
  stdenvNoCC,
  elgato4k-linux,
  udevCheckHook,
}:

stdenvNoCC.mkDerivation {
  pname = "elgato4k-udev-rules";
  inherit (elgato4k-linux) version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ udevCheckHook ];
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 ${elgato4k-linux}/lib/udev/rules.d/70-elgato4k.rules \
      $out/lib/udev/rules.d/70-elgato4k.rules
    runHook postInstall
  '';

  meta = {
    description = "udev rules for Elgato 4K X and 4K S capture cards";
    homepage = "https://github.com/13bm/elgato4k-linux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ilya-epifanov ];
    platforms = lib.platforms.linux;
  };
}
