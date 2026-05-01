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
        release = "0.1.4";
        name = "mkl_service-2.6.1-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-Y5cPfHE/51QcKkQVdAKxu7/BC+/dM8odEAH/KOZ7QdI=";
      }
    else if pyVersion == "3.12" then
      {
        release = "0.1.4";
        name = "mkl_service-2.6.1-cp312-cp312-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-8Uo+0m1Fl1clw2QzSj7Hyx2t9JrN+46y+ugXkag4x6o=";
      }
    else if pyVersion == "3.13" then
      {
        release = "0.1.4";
        name = "mkl_service-2.6.1-cp313-cp313-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-HdzTEaVZMIo2bKMJKBWfvAQd9rsKgR415HDH7Ai3YTs=";
      }
    else if pyVersion == "3.14" then
      {
        release = "0.1.4";
        name = "mkl_service-2.6.1-cp314-cp314-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-KmQMADrlGeormDvLIhOP1svBgNEoaHIUKmAVz9fNMkI=";
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
  version = "2.6.1";
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
