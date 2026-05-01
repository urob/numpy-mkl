# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "intel-openmp";
  version = "2026.0.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/6b/52/ad8da758c96299c27ac1f0345979f9202a517c4f18ef6a1e9b7a781d6948/intel_openmp-2026.0.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-xGBcY4QNbcAYhhD50NzFrmxzyYj5jDbEvYB7y9Dec7s=";
  };

  dependencies = [
    (callPackage ./intel-cmplr-lib-ur.nix { }) # ==2026.0.0
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
