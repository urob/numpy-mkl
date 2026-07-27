# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "intel-openmp";
  version = "2026.1.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/72/23/60aeb428e6b1fb34fb81d4970d91ff8b5deeeeb446e1628bd78f9e3d1f8b/intel_openmp-2026.1.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-5oh/cBt9IyPtFHAIiTua8i5RGqqX4PycN+uL4kpTZrA=";
  };

  dependencies = [
    (callPackage ./intel-cmplr-lib-ur.nix { }) # ==2026.1.0
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel OpenMP* Runtime Library";
    homepage = "https://pypi.org/project/intel-openmp/";
    license = "Intel End User License Agreement for Developer Tools";
  };
}
