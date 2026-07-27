# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "tbb";
  version = "2023.1.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/25/0c/0266c71e3fa50a71db5ce8a1d0807863df3215c5f7b5fe7c98b257561138/tbb-2023.1.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-ZK01JBxzallUmPU0Or7I6qogPp/g29v0uG03xaOrHZw=";
  };

  dependencies = [
    (callPackage ./tcmlib.nix { }) # ==1.*
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel® oneAPI Threading Building Blocks (oneTBB)";
    homepage = "https://pypi.org/project/tbb/";
    license = "Intel Simplified Software License";
  };
}
