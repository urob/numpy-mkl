{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
  python,
  stdenv,
}:
let
  pname = "numpy";
  wheel = (import ./lib.nix { inherit lib; }).wheelFor {
    inherit pname python;
    abi = "cpython";
  };

  mkl = callPackage ./mkl/mkl.nix { };
  mkl-service = callPackage ./mkl-service.nix { };

  rpathExtras = lib.makeLibraryPath [
    stdenv.cc.cc
    stdenv.cc.libc
  ];
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
    mkl-service
  ];

  # Add cc and libc libraries to runtime path of all numpy libs.
  # Redundant paths are removed during the main fixup phase.
  preFixup = ''
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${rpathExtras} {} \;
  '';

  pythonImportsCheck = [ "numpy" ];

  meta = {
    description = "MKL-accelerated NumPy package";
    homepage = "https://github.com/urob/numpy-mkl";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
  };
}
