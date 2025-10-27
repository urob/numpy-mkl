# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "intel-cmplr-lib-ur";
  version = "2025.3.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/71/33/94785f0575f7319e57788169ef15e504c1e9e9744f04e0b9e00390e1f533/intel_cmplr_lib_ur-2025.3.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-NeRXZJB8EACQ2Ny3XU0xqn3DMOXy2IcDLJ60fT4p1D4=";
  };

  dependencies = [
    (callPackage ./umf.nix { }) # ==1.0.*
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
