# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "onemkl-license";
  version = "2026.0.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/cc/fa/7c9af1e1fcea378257958355f7f2b80d6cc50a36ceebec0ad2fa9bd6b538/onemkl_license-2026.0.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-k5BYpPNIWYY+qjc0tnjogM0c5fWJRY/uoRi/IhJRQ0E=";
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
