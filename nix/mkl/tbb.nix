# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "tbb";
  version = "2023.0.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/aa/d2/9a994ce9b18182b04783282eba77e236d23919acf42a886d72fe14fc78a4/tbb-2023.0.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-SC9XZWOG6hS5bo2jaz/MTNiAg07w8yi6Ceji48Y5KF4=";
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
