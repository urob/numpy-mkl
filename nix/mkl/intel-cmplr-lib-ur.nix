# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "intel-cmplr-lib-ur";
  version = "2026.1.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/8e/06/da0fcd62ee4672489ede80f322eec61b48a38695b0a5072d6d1075b37197/intel_cmplr_lib_ur-2026.1.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-dLZKzoJ3sDGqNjKNyPh/f5WabKTaW2jGmSPTcoPgFmQ=";
  };

  dependencies = [
    (callPackage ./umf.nix { }) # ==1.1.*
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel® oneAPI Unified Runtime Libraries package";
    homepage = "https://pypi.org/project/intel-cmplr-lib-ur/";
    license = "Intel End User License Agreement for Developer Tools";
  };
}
