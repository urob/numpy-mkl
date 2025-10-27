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
    if pyVersion == "3.10" then
      {
        release = "0.1.0";
        name = "mkl_service-2.6.0-cp310-cp310-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-PzqLIFdPmbVEc7KMtEWH28PGwQOBXC4ptW/VOj7uoFg=";
      }
    else if pyVersion == "3.11" then
      {
        release = "0.1.0";
        name = "mkl_service-2.6.0-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-QLL6L1Por51JAW0rcrDAPBPCv8aAqmRLRaGiHIeKa28=";
      }
    else if pyVersion == "3.12" then
      {
        release = "0.1.0";
        name = "mkl_service-2.6.0-cp312-cp312-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-FZCN1EzIOqgiIiyDzBX6LzEgGkPMCjeUmmTPN3vyeIc=";
      }
    else if pyVersion == "3.13" then
      {
        release = "0.1.0";
        name = "mkl_service-2.6.0-cp313-cp313-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-QV1bJ+xH373jFsT7OH8TNEkXo/s1QyTYnY9ffaWLysU=";
      }
    else if pyVersion == "3.14" then
      {
        release = "0.1.0";
        name = "mkl_service-2.6.0-cp314-cp314-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl";
        hash = "sha256-IHc6ebChW+fqLezz46EnSRp1gW+S/OZ/as3TbQH6T7I=";
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
  pname = "numpy";
  version = "2.6.0";
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
    find $out -name '*.so' -exec patchelf --add-rpath ${rpathExtras} {} \;
  '';

  pythonImportsCheck = [ "mkl" ];

  meta = {
    description = "Python hooks for Intel® oneAPI Math Kernel Library (oneMKL) runtime control settings";
    homepage = "https://github.com/urob/numpy-mkl";
    license = lib.licenses.bsd3;
  };
}
