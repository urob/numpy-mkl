# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "umf";
  version = "1.1.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/c4/72/2e0182f4e6a727a15d0a8a99a82182a4f5bdec1a4f5767acfd2abdc72070/umf-1.1.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-VnFSxe5rjhbMVrKaipprkY3h/r+Jh39x6i6CR+85/DI=";
  };

  dependencies = [
    (callPackage ./tcmlib.nix { }) # >=1.5
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find $out \( -name '*.so' -o -name '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Unified Memory Framework";
    homepage = "https://pypi.org/project/umf/";
    license = "Apache-2.0 with LLVM exceptions";
  };
}
