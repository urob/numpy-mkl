# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "mkl";
  version = "2025.3.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/6d/b4/ef531295ed33b929c6c5214421eeebe370f1be22536b6956b4aaf18fdbc5/mkl-2025.3.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-e4H10uA0Y3sYfKWGZoeMToiJmIp4454LbukuhGVo9mA=";
  };

  dependencies = [
    (callPackage ./onemkl-license.nix { }) # ==2025.3.0
    (callPackage ./intel-openmp.nix { }) # <2026,>=2024
    (callPackage ./tbb.nix { }) # ==2022.*
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find $out \( -name '*.so' -o -name '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel® oneAPI Math Kernel Library";
    homepage = "https://pypi.org/project/mkl/";
    license = "Intel Simplified Software License";
  };
}
