_final: prev:
let
  mklOverlay = pyFinal: _pyPrev: {
    numpy = pyFinal.callPackage ./numpy.nix { };
    scipy = pyFinal.callPackage ./scipy.nix { };

    # Exposed to avoid conflicts in case any dependency is added explicitly.
    # The derivations source each other by path rather than through the
    # package set, so that overriding an attribute here cannot desync a
    # package from the resolution it was pinned and tested against.
    mkl-service = pyFinal.callPackage ./mkl-service.nix { };
    intel-cmplr-lib-ur = pyFinal.callPackage ./mkl/intel-cmplr-lib-ur.nix { };
    intel-openmp = pyFinal.callPackage ./mkl/intel-openmp.nix { };
    mkl = pyFinal.callPackage ./mkl/mkl.nix { };
    onemkl-license = pyFinal.callPackage ./mkl/onemkl-license.nix { };
    tbb = pyFinal.callPackage ./mkl/tbb.nix { };
    tcmlib = pyFinal.callPackage ./mkl/tcmlib.nix { };
    umf = pyFinal.callPackage ./mkl/umf.nix { };
  };
in
{
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ mklOverlay ];
}
