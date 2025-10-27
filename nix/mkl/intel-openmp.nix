# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "intel-openmp";
  version = "2025.3.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/6a/87/68241d0b532f0e41d5b2928b640b00f9bb48945df9921df1d878f42c1d38/intel_openmp-2025.3.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-lI2daiLtdkMwWnF8KsJni66MEa2v1eTTD5A8+ZM7SmA=";
  };

  dependencies = [
    (callPackage ./intel-cmplr-lib-ur.nix { }) # ==2025.3.0
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find $out \( -name '*.so' -o -name '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel® OpenMP* Runtime Library";
    homepage = "https://pypi.org/project/intel-openmp/";
    license = "Intel End User License Agreement for Developer Tools";
  };
}
