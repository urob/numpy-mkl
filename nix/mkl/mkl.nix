# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "mkl";
  version = "2026.1.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/61/da/4921e17b1f455f7fed30d5cc0964f3289eee6a6cb03cdf7d5e20c14bd025/mkl-2026.1.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-TVomRJgYqK69SyqvaykYMeaR+c90sVLfSbmc9Iu9U2A=";
  };

  dependencies = [
    (callPackage ./onemkl-license.nix { }) # ==2026.1.0
    (callPackage ./intel-openmp.nix { }) # <2027,>=2025
    (callPackage ./tbb.nix { }) # ==2023.*
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel® oneAPI Math Kernel Library";
    homepage = "https://pypi.org/project/mkl/";
    license = "Intel Simplified Software License";
  };
}
