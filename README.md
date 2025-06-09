# numpy-mkl

This repository provides binary wheels for NumPy and SciPy, linked to Intel's high-performance
[oneAPI Math Kernel
Library](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html) for Intel CPUs.
The wheels are accessible through a custom Python Package Index (PyPI) and can be installed with
`pip` or `uv`.

## Installation

MKL-accelerated wheels are available for 64-bit versions of Linux and Windows. There are no
prerequisites apart from `pip` or `uv`; all dependencies are automatically installed by the package
manager.

**uv**

```sh
# Run this from project directory
uv init
uv add numpy scipy --index https://urob.github.io/numpy-mkl
```

**pip**

```sh
pip install numpy scipy --extra-index-url https://urob.github.io/numpy-mkl
```

## Alternatives

The usual way to obtain MKL-accelerated NumPy and SciPy packages is through
[Anaconda](https://www.anaconda.com/) or [Conda-forge](https://conda-forge.org/). The purpose of
this repository is to provide an alternative for users who prefer to use `pip` or `uv` for package
management. Other alternatives are listed below.

|                                                                                                                                 | MKL | PyPI | Notes                      |
| ------------------------------------------------------------------------------------------------------------------------------- | --- | ---- | -------------------------- |
| This repository                                                                                                                 | Yes | Yes  |                            |
| [Intel(r) Distribution for Python](https://www.intel.com/content/www/us/en/developer/tools/oneapi/distribution-for-python.html) | Yes | Yes  | Does not support NumPy 2.x |
| [Numpy-mkl-wheels](https://github.com/cgohlke/numpy-mkl-wheels)                                                                 | Yes | No   | No Linux wheels            |
| [Python Package Index](https://pypi.org/)                                                                                       | No  | Yes  | Slow on Intel CPUs         |

## Technical details

Linux wheels are built with `gcc` on Ubuntu 22.04. Windows wheels are built with `msvc` (numpy) and
`mingw-w64` (scipy) on Windows Server 2022. These compilers showed the most consistent runtime
performance in a series of [benchmarks](benchmarks/benchmarks.py), even in comparison to
`icx`-compiled wheels.

## References

- [Intel(r) oneMKL Release
  Notes](https://www.intel.com/content/www/us/en/developer/articles/release-notes/onemkl-release-notes.html)
- [Intel(r) oneAPI Release
  Notes](https://www.intel.com/content/www/us/en/developer/articles/release-notes/intel-oneapi-toolkit-release-notes.html)
