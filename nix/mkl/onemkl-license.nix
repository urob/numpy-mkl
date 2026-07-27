# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "onemkl-license";
  version = "2026.1.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/e3/ef/8437c187319e779a76f4dbb468a1863d729297d79a1b5f44b10a58c96ec2/onemkl_license-2026.1.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-Of2ClkivksngPCK6Io8HF02Cmqov48X2zXBzuOuKmAU=";
  };

  dependencies = [
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Intel® oneAPI Math Kernel Library";
    homepage = "https://pypi.org/project/onemkl-license/";
    license = "Intel Simplified Software License";
  };
}
