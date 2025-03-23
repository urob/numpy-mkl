# numpy-mkl

NumPy and SciPy wheels linked against Intel's high performance
[oneMLK](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html)
BLAS and LAPACK libraries for Intel CPUs. The wheels are available from a Python Package
Index URL for convenient installation with `pip` or `uv`.

## Installation

```shell
pip install numpy --extra-index-url https://urob.github.io/numpy-mkl
```

## Alternatives

- The `conda-forge` and `anaconda` conda channels contain comparable NumPy and SciPy
  builds. The main benefit of this index is that it eliminates the dependence on a conda,
  allowing to install high performance scientific computing libraries with the convenience
  of `pip` or `uv`.
- Intel's [Distribution for
  Python](https://www.intel.com/content/www/us/en/developer/tools/oneapi/distribution-for-python.html)
  includes MKL-linked versions for NumPy releases `<= 1.26`.
- Christoph Golke maintains custom [Windows wheels](https://github.com/cgohlke/numpy-mkl-wheels) for
  NumPy and SciPy.
