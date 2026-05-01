# Do not edit, generated automatically by <maintain-nix-deps.py>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}:
buildPythonPackage rec {
  pname = "tcmlib";
  version = "1.5.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/60/24/aa409bb20703acc70cf4d3bc620a55c789639c2995b2667fb44ae7236ec9/tcmlib-1.5.0-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-nXwBz/Narpv1OQtiBoDr3xCn0hHCLWSIonoClQLn0Ko=";
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
    description = "Thread Composability Manager";
    homepage = "https://pypi.org/project/tcmlib/";
    license = "Intel Simplified Software License";
  };
}
