_final: prev:
let
  mklOverlay = pyFinal: _pyPrev: {
    numpy = pyFinal.callPackage ./numpy.nix { };
    scipy = pyFinal.callPackage ./scipy.nix { };

    # Just to avoid conflicts in case any dependency is added explicitly.
    # numpy.nix and scipy.nix source the patched versions regardless.
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
