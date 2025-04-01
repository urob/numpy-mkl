# numpy-mkl

This repository provides NumPy and SciPy wheels linked against Intel's high performance
[oneMLK](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html) BLAS and LAPACK
libraries for Intel CPUs.

The wheels have been published to a custom Python Package Index for convenient installation with
`pip` or `uv`. See below for installation instructions.

## Installation (pip)

```sh
pip install numpy scipy --extra-index-url https://urob.github.io/numpy-mkl
```

## Installation (uv)

```sh
# Run this from project directory
uv init
uv add numpy scipy --index https://urob.github.io/numpy-mkl
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

## References

- [Intel(r) oneMKL Release
  Notes](https://www.intel.com/content/www/us/en/developer/articles/release-notes/onemkl-release-notes.html)
- [Intel(r) oneAPI Release
  Notes](https://www.intel.com/content/www/us/en/developer/articles/release-notes/intel-oneapi-toolkit-release-notes.html)
