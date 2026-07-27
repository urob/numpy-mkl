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
    if pyVersion == "3.12" then
      {
        release = "0.3.7";
        name = "numpy-2.5.1-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-rawfS+cSgxSs/ybgalia0RdGvuYcK73MODpp1YYOJaQ=";
      }
    else if pyVersion == "3.13" then
      {
        release = "0.3.7";
        name = "numpy-2.5.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-P0KZ+SIiX/6DuWRx/Iya2SjBieGGCP6t9DucOp0L4vs=";
      }
    else if pyVersion == "3.14" then
      {
        release = "0.3.7";
        name = "numpy-2.5.1-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-1uZomlYo5PNgMG9aVchQBsNIoA56bA6yveapGDKFU0U=";
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
  version = "2.5.1";
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
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${rpathExtras} {} \;
  '';

  pythonImportsCheck = [ "numpy" ];

  meta = {
    description = "MKL-accelerated NumPy package";
    homepage = "https://github.com/urob/numpy-mkl";
    license = lib.licenses.bsd3;
  };
}
