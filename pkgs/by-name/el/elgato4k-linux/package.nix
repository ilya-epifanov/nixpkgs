{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  nix-update-script,
  udevCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "elgato4k-linux";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "13bm";
    repo = "elgato4k-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FBME40JCZ/Vrgu2Wc311mmClkJFKDvkjerhvuuy2tO4=";
  };

  cargoHash = "sha256-tHZKPZqivmlgVonLd0ZItVAufxjuRtS66OAwYTwCv+g=";

  # Disable the bundled self-update check that fetches releases from GitHub.
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];

  buildInputs = [ libusb1 ];

  postInstall = ''
    install -Dm644 ${./70-elgato4k.rules} $out/lib/udev/rules.d/70-elgato4k.rules
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Control utility for Elgato 4K X and 4K S capture cards";
    longDescription = ''
      Unofficial command-line tool to control Elgato 4K X (UVC) and 4K S (HID)
      capture cards on Linux. Supports HDR tone mapping, HDMI color range,
      EDID source selection, custom EDID presets, USB speed switching,
      audio input selection, video scaler control, and status/firmware
      version readback.
    '';
    homepage = "https://github.com/13bm/elgato4k-linux";
    changelog = "https://github.com/13bm/elgato4k-linux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ilya-epifanov ];
    mainProgram = "elgato4k-linux";
    platforms = lib.platforms.linux;
  };
})
