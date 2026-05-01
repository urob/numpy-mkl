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
        release = "0.1.9";
        name = "scipy-1.17.1-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-cqjIQxI8QdFUMlgBVf9/tO+dAVfW6BAGn++thBGpR3E=";
      }
    else if pyVersion == "3.12" then
      {
        release = "0.1.9";
        name = "scipy-1.17.1-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-OJ8C4xgsq3BEgA1g3pQqhfUV+xQc6G9YiGAGGAQMhkE=";
      }
    else if pyVersion == "3.13" then
      {
        release = "0.1.9";
        name = "scipy-1.17.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-GTl/IljuHfJxC8cCwD12PrFzXuwhfXX8dR19kZKuNTI=";
      }
    else if pyVersion == "3.14" then
      {
        release = "0.1.9";
        name = "scipy-1.17.1-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-d5bPAf+4WI4PFCOJkcgtfyM3YY9thHPiQFjpXRMFXFs=";
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
  version = "1.17.1";
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
