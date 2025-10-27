# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "tbb";
  version = "2022.3.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/e3/9e/b7f1f7af53580e4e8cf39cf51b14c8e295d767b3ae9d78b5007d6058cfc8/tbb-2022.3.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-p+Eiy5im+II5QDQaoyPc3/+nfjZxKiKhrjp2Qw+p9BI=";
  };

  dependencies = [
    (callPackage ./tcmlib.nix { }) # ==1.*
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find $out \( -name '*.so' -o -name '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel® oneAPI Threading Building Blocks (oneTBB)";
    homepage = "https://pypi.org/project/tbb/";
    license = "Intel Simplified Software License";
  };
}
