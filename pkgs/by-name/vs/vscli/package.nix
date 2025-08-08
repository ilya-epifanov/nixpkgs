{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "vscli";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "michidk";
    repo = "vscli";
    rev = "v${version}";
    hash = "sha256-VQ1RLFFA1Tx6/vdgyQnpiLE7S3pmGwA6MQE7qkTVlFA=";
  };

  cargoHash = "sha256-Jma83NiQQVaI72gfX9hFOtjzylBIlOs7g0Q17l4+nBc=";

  meta = {
    homepage = "https://gitlab.com/michidk/vscli";
    description = "A CLI/TUI which makes it easy to launch Visual Studio Code (vscode) dev containers. Also supports other editors like Cursor.";
    mainProgram = "vscli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iepifanov ];
  };
}
