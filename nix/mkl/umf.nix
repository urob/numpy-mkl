# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "umf";
  version = "1.0.2";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/27/8e/4a90b6aa955268988e7491f502b7ac2bd65cb954b4979bfcc892cf019b50/umf-1.0.2-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-700USiAHpzoaIu5XXuT1oYlKIGUyxvbXe0z1SGQ1Avs=";
  };

  dependencies = [
    (callPackage ./tcmlib.nix { }) # >=1.4
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find $out \( -name '*.so' -o -name '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Unified Memory Framework";
    homepage = "https://pypi.org/project/umf/";
    license = "Apache-2.0 with LLVM exceptions";
  };
}
