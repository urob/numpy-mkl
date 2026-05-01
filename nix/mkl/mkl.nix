# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "mkl";
  version = "2026.0.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/91/97/06ad1072db8a3c4d1e6237badf660c4c754d2b513264996121c2b666d65d/mkl-2026.0.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-SpUl3dZxtCL+38aQ3ZJwvrZcjL1HBEtS0qTj9hYsneY=";
  };

  dependencies = [
    (callPackage ./onemkl-license.nix { }) # ==2026.0.0
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
