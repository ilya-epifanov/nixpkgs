{
  lib,
  asn1crypto,
  buildPythonPackage,
  cryptography,
  dnspython,
  dsinternals,
  fetchFromGitHub,
  impacket,
  ldap3,
  pyasn1,
  pycryptodome,
  pyopenssl,
  pythonOlder,
  requests,
  requests-ntlm,
  unicrypto,
  setuptools,
}:

buildPythonPackage rec {
  pname = "certipy-ad";
  version = "4.8.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ly4k";
    repo = "Certipy";
    tag = version;
    hash = "sha256-Era5iNLJkZIRvN/p3BiD/eDiDQme24G65VSG97tuEOQ=";
  };

  postPatch = ''
    # pin does not apply because our ldap3 contains a patch to fix pyasn1 compability
    substituteInPlace setup.py \
      --replace "pyasn1==0.4.8" "pyasn1"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    asn1crypto
    cryptography
    dnspython
    dsinternals
    impacket
    ldap3
    pyasn1
    pycryptodome
    pyopenssl
    requests
    requests-ntlm
    setuptools
    unicrypto
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "certipy" ];

  meta = with lib; {
    description = "Library and CLI tool to enumerate and abuse misconfigurations in Active Directory Certificate Services";
    mainProgram = "certipy";
    homepage = "https://github.com/ly4k/Certipy";
    changelog = "https://github.com/ly4k/Certipy/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
