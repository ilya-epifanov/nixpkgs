{ fetchurl
, unzip
, lib
, tree
, stdenv
}:

let
  bits = if stdenv.hostPlatform.system == "x86_64-linux" then "x64" else "ia32";
  version = "0.87.0";
in
stdenv.mkDerivation {
  pname = "nwjs-ffmpeg-prebuilt";
  inherit version;

  src =
    let
      hashes = {
        "x64" = "0ala43qhg0zi662d3yahbcxrnpx9439jlqwdsi58ck5p36ih9mp0";
        "ia32" = "0ala43qhg0zi662d3yahbcxrnpx9439jlqwdsi58ck5p36ih9mp0";
      };
    in fetchurl {
      url = "https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/download/${version}/${version}-linux-${bits}.zip";
      sha256 = hashes."${bits}";
    };
  sourceRoot = ".";

  nativeBuildInputs = [
    tree unzip
  ];

  installPhase = ''
      runHook preInstall

      tree
      mkdir -p $out/lib
      cp -R libffmpeg.so $out/lib/

      runHook postInstall
    '';

  meta = with lib; {
    description = "An app runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [ "i686-linux" "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = [ maintainers.mikaelfangel ];
    mainProgram = "nw";
    license = licenses.bsd3;
  };
}
