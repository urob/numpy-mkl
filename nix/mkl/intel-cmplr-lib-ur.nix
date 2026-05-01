# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "intel-cmplr-lib-ur";
  version = "2026.0.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/15/6d/b981353d0ba8dc6d54510aba97f67ddce3872a693f41841bb77a120f512c/intel_cmplr_lib_ur-2026.0.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-X7dSk+fx+Dd82jqsRPTnwMHdOOKB/s76dsoUWTgnY6Q=";
  };

  dependencies = [
    (callPackage ./umf.nix { }) # ==1.1.*
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find $out \( -name '*.so' -o -name '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel® oneAPI Unified Runtime Libraries package";
    homepage = "https://pypi.org/project/intel-cmplr-lib-ur/";
    license = "Intel End User License Agreement for Developer Tools";
  };
}
