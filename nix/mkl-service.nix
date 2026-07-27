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
  pyVersion = lib.versions.majorMinor python.version;

  # <<< Automatically generated, do not edit.
  wheel =
    if pyVersion == "3.11" then
      {
        release = "0.3.8";
        name = "mkl_service-2.8.0-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-xvki8kTp2uAbXbQhvfWN99qO+3AezIensywQGKA/i/A=";
      }
    else if pyVersion == "3.12" then
      {
        release = "0.3.8";
        name = "mkl_service-2.8.0-cp312-cp312-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-bfyGYw+4Q1Fuh/cjZJY282R7kZUi7QDwDUHi0yR5x9U=";
      }
    else if pyVersion == "3.13" then
      {
        release = "0.3.8";
        name = "mkl_service-2.8.0-cp313-cp313-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-l2dMmGy/m4CIIF3OX7ZA/X916uDdBumq0F0qKJfXPOY=";
      }
    else if pyVersion == "3.14" then
      {
        release = "0.3.8";
        name = "mkl_service-2.8.0-cp314-cp314-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-XK+8A0s+rB/nZT/CQnoLtbGlQ9GeHV1tCewLcwDluNU=";
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

  rpathExtras = lib.makeLibraryPath [ stdenv.cc.libc ];
in
buildPythonPackage rec {
  pname = "mkl-service";
  version = "2.8.0";
  format = "wheel";

  src = fetchurl {
    url = makeUrl wheel;
    inherit (wheel) hash;
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
  };
}
