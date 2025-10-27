# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "onemkl-license";
  version = "2025.3.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/88/11/b43e8cde058c368ce7f8f9b1ca9f812f7397e4309148da7d24cb6b81b513/onemkl_license-2025.3.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-qBCyW7JKkNtEktgccc3hMYPYlRziaWDW3FbU9OPclf8=";
  };

  dependencies = [
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
    homepage = "https://pypi.org/project/onemkl-license/";
    license = "Intel Simplified Software License";
  };
}
