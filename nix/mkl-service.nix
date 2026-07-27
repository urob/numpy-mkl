{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
  python,
  stdenv,
}:
let
  pname = "mkl-service";
  wheel = (import ./lib.nix { inherit lib; }).wheelFor {
    inherit pname python;
    abi = "cpython";
  };

  mkl = callPackage ./mkl/mkl.nix { };

  rpathExtras = lib.makeLibraryPath [ stdenv.cc.libc ];
in
buildPythonPackage {
  inherit pname;
  inherit (wheel) version;
  format = "wheel";

  src = fetchurl {
    inherit (wheel) url hash;
  };

  dependencies = [
    mkl
  ];

  # Add libc libraries to runtime path of all mkl-service libs.
  # Redundant paths are removed during the main fixup phase.
  preFixup = ''
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${rpathExtras} {} \;
  '';

  pythonImportsCheck = [ "mkl" ];

  meta = {
    description = "Python hooks for Intel® oneAPI Math Kernel Library (oneMKL) runtime control settings";
    homepage = "https://github.com/urob/numpy-mkl";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
  };
}
