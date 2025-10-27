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
  numpy = callPackage ./numpy.nix { };
  pyVersion = lib.versions.majorMinor python.version;

  # <<< Automatically generated, do not edit.
  wheel =
    if pyVersion == "3.11" then
      {
        release = "0.1.0";
        name = "scipy-1.16.2-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-nURdElRUE+ylZ4bVFN84qxUUUSTGScQO/dK8QIDraQI=";
      }
    else if pyVersion == "3.12" then
      {
        release = "0.1.0";
        name = "scipy-1.16.2-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-P9Migl9RjCrpztVUPYgwRn7zdR3IJUHF1mXILKGAMuo=";
      }
    else if pyVersion == "3.13" then
      {
        release = "0.1.0";
        name = "scipy-1.16.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-qWAGblvug4Vr/TWQu/ezmlGP19kPobkj3R4g3jcIzqw=";
      }
    else if pyVersion == "3.14" then
      {
        release = "0.1.1";
        name = "scipy-1.16.2-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-ftCu2o7JAI0xxBtcEwXSrSR24+g+QIRvoEMVIyQE5VA=";
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
  pname = "scipy";
  version = "1.16.2";
  format = "wheel";

  src = fetchurl {
    url = makeUrl wheel;
    inherit (wheel) hash;
  };

  dependencies = [
    mkl
    mkl-service
    numpy
  ];

  # Add cc and libc libraries to runtime path of all scipy libs.
  # Redundant paths are removed during the main fixup phase.
  preFixup = ''
    find $out -name '*.so' -exec patchelf --add-rpath ${rpathExtras} {} \;
  '';

  pythonImportsCheck = [ "scipy" ];

  meta = {
    description = "MKL-accelerated SciPy package";
    homepage = "https://github.com/urob/numpy-mkl";
    license = lib.licenses.bsd3;
  };
}
