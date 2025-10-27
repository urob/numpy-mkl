# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "tcmlib";
  version = "1.4.1";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/a1/a4/38e8b5a27b66ab286168ba6c449771ed71d71ec76524e7f12401474a5151/tcmlib-1.4.1-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-DVvZjbSNMb7H/tulwjWZv5rkPHAW1MOUbSUkLTIM7ok=";
  };

  dependencies = [
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find $out \( -name '*.so' -o -name '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Thread Composability Manager";
    homepage = "https://pypi.org/project/tcmlib/";
    license = "Intel Simplified Software License";
  };
}
