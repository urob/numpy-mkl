# Do not edit, generated automatically by <tools/update-nix-wheels>.
{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
  python,
}:
let
  pname = "umf";
  wheel = (import ../lib.nix { inherit lib; }).wheelFor { inherit pname python; };
in
buildPythonPackage rec {
  inherit pname;
  inherit (wheel) version;
  format = "wheel";

  src = fetchurl {
    inherit (wheel) url hash;
  };

  dependencies = [
    (callPackage ./tcmlib.nix { })
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find "$out" \( -iname '*.so' -o -iname '*.so.*' \) -exec patchelf \
      --add-rpath ${lib.makeLibraryPath dependencies} {} \;
  '';

  doCheck = false;

  meta = {
    description = "Unified Memory Framework";
    homepage = "https://pypi.org/project/umf/";
    license = "Apache-2.0 with LLVM exceptions";
    platforms = [ "x86_64-linux" ];
  };
}
