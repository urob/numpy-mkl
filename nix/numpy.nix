{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
  python,
  stdenv,
}:
let
  mkl = callPackage ./mkl/mkl.nix { };
  mkl-service = callPackage ./mkl-service.nix { };
  pyVersion = lib.versions.majorMinor python.version;

  # <<< Automatically generated, do not edit.
  wheel =
    if pyVersion == "3.11" then
      {
        release = "0.1.0";
        name = "numpy-2.3.4-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-VRmakVCqjlQGSbhG+AbkT3o8jj0HhiI0Nwpuo/XP8zM=";
      }
    else if pyVersion == "3.12" then
      {
        release = "0.1.0";
        name = "numpy-2.3.4-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-y+jlq0+05a638x3xo/5itx44aXf94dGX3zIdToKFEOo=";
      }
    else if pyVersion == "3.13" then
      {
        release = "0.1.0";
        name = "numpy-2.3.4-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-R8Bsl1QYkNufuayAuvhkeYk4XORtx6a0qUXLcfR25Ww=";
      }
    else if pyVersion == "3.14" then
      {
        release = "0.1.0";
        name = "numpy-2.3.4-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-yr1nGp/AbzMXluap64kUNetxlOdP6CyX6GsWXAN4CYU=";
      }
    else
      {
        release = "";
        name = "";
        hash = "";
      };
  # >>>

  baseurl = "https://github.com/urob/numpy-mkl/releases/download";
  makeUrl =
    wheel:
    lib.strings.concatStringsSep "/" [
      baseurl
      wheel.release
      wheel.name
    ];

  rpathExtras = lib.makeLibraryPath [
    stdenv.cc.cc
    stdenv.cc.libc
  ];
in
buildPythonPackage rec {
  pname = "numpy";
  version = "2.3.4";
  format = "wheel";

  src = fetchurl {
    url = makeUrl wheel;
    inherit (wheel) hash;
  };

  dependencies = [
    mkl
    mkl-service
  ];

  # Add cc and libc libraries to runtime path of all numpy libs.
  # Redundant paths are removed during the main fixup phase.
  preFixup = ''
    find $out -name '*.so' -exec patchelf --add-rpath ${rpathExtras} {} \;
  '';

  pythonImportsCheck = [ "numpy" ];

  meta = {
    description = "MKL-accelerated NumPy package";
    homepage = "https://github.com/urob/numpy-mkl";
    license = lib.licenses.bsd3;
  };
}
