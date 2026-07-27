# Drop-in replacement for mkl-service's own import-time hook.
#
# Upstream only registers MKL's DLL directory, and only for Windows venvs (it
# checks for pyvenv.cfg and assumes '{sys.exec_prefix}/Library/bin'), so it is a
# no-op on Linux, and for global and --user installs. Instead, locate the installed
# 'mkl' package through its metadata, which works regardless of where it ended up.
#
# This runs before 'mkl/__init__.py' imports the '_mklinit' extension, which is
# the only ordering requirement.

import contextlib
import ctypes
import os
from importlib.metadata import PackageNotFoundError, files

with contextlib.suppress(
    AttributeError, FileNotFoundError, PackageNotFoundError, StopIteration, TypeError
):
    if os.name == 'nt':
        # Add the MKL library path to the DLL search path.
        dll = next(p for p in files('mkl') if p.match('*mkl_rt*.dll'))
        os.add_dll_directory(dll.locate().resolve().parent)
    else:
        # There's no easy way to expand LD_LIBRARY_PATH at runtime on Linux.
        # Instead preload the MKL library directly.
        lib = next(p for p in files('mkl') if p.match('*libmkl_rt.so*'))
        ctypes.CDLL(lib.locate().resolve(), mode=ctypes.RTLD_GLOBAL)
