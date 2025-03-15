{
  appimageTools,
  fetchurl,
  lib,
  webkitgtk_4_1,
}:
let
  pname = "mididash";
  version = "0.4.1";
  src = fetchurl {
    url = "https://github.com/tiagolr/mididash/releases/download/v${version}/Mididash_${version}_amd64.AppImage";
    hash = "sha256-wX8rui6RWpAGLDvdHO9KyKfuc+QilQH37Bd2HcEWaa4=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/{applications,pixmaps}
    cp ${appimageContents}/Mididash.desktop $out/share/applications/${pname}.desktop
    cp ${appimageContents}/Mididash.png $out/share/pixmaps/${pname}.png
  '';

  extraPkgs = pkgs: with pkgs; [ webkitgtk_4_1 ];

  meta = with lib; {
    homepage = "https://github.com/tiagolr/mididash/";
    description = "Mididash is an open source MIDI routing software with a node-based interface and Lua scripting. A modern take on programs like MIDI-OX";
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "mididash";
    changelog = "https://github.com/tiagolr/mididash/releases/tag/v${version}";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ilya-epifanov ];
  };
}
