{
  lib,
  fetchFromGitHub,
  python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "hvcc";
  version = "0.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Wasted-Audio";
    repo = "hvcc";
    tag = "v${version}";
    hash = "sha256-V+KQum1PFzAlu79vID7xZgVW6q0M1UAMSeF0f3oSnXg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];
  propagatedBuildInputs = with python3.pkgs; [
    jinja2
    importlib-resources
    pydantic
    (
      buildPythonPackage {
        pname = "wstd2daisy";
        version = "0.5.3";
        pyproject = true;

        src = fetchFromGitHub {
          owner = "Wasted-Audio";
          repo = "json2daisy";
          rev = "71e2982454d3410c5e4479c2d0dfa575a9826d17";
          hash = "sha256-1QKYx9gocAKKWCP9uEmuhtFWCptCd+vBlga5keBxkzY=";
        };

        build-system = [
          setuptools-scm
        ];

        dependencies = [
          jinja2
        ];
      }
    )
  ];

  doCheck = true;

  meta = {
    description = "Heavy Compiler Collection";
    homepage = "https://wasted-audio.github.io/hvcc/";
    license = lib.licenses.gpl3Only;
    mainProgram = "animdl";
    maintainers = with lib.maintainers; [ iepifanov ];
    platforms = [ "x86_64-linux" ];
  };
}
