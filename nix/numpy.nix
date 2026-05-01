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
        release = "0.1.11";
        name = "numpy-2.4.4-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-YdJq881EKeiJpM2rJa8r9zzQwKXkBRCzfkCWUnLycSU=";
      }
    else if pyVersion == "3.12" then
      {
        release = "0.1.11";
        name = "numpy-2.4.4-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-SV27v3jcOTEDmjlNE25peSNN01Syf6Cg1wH+5NtGCo8=";
      }
    else if pyVersion == "3.13" then
      {
        release = "0.1.11";
        name = "numpy-2.4.4-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-T37NXLBsN07ShGIeptdE7d71zPfkLf6YujSC3rospts=";
      }
    else if pyVersion == "3.14" then
      {
        release = "0.1.11";
        name = "numpy-2.4.4-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-ui49SKPfKjLxcWRXTg6aba+E+aUjpSKFEhrOnUJm0A0=";
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
  version = "2.4.4";
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
