# numpy-mkl

[![NumPy](https://img.shields.io/badge/NumPy-2.1_%7C_2.2_%7C_2.3-013243)](https://urob.github.io/numpy-mkl/numpy/)
[![SciPy](https://img.shields.io/badge/SciPy-1.15_%7C_1.16-8caae6)](https://urob.github.io/numpy-mkl/scipy/)
[![mkl-service](https://img.shields.io/badge/mkl--service-2.4_%7C_2.5-3b5526)](https://urob.github.io/numpy-mkl/mkl-service/)

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

## Cross-platform collaborations

MKL is only available on `x86-64` architectures, excluding macOS systems. When using `uv`, one can
use [platform markers](https://peps.python.org/pep-0508/#environment-markers) to automatically
install MKL-linked versions of NumPy and SciPy when on a compatible system, and otherwise fall back
to the default versions from PyPI.

Below is a simple illustration, which falls back to the PyPI packages on macOS.[^1] To
install the environment, copy the following snippet into `pyproject.toml` and then run `uv sync`.
This will install a virtual environment in `.venv`, which can be activated on the command line or
via most Python editors.

```toml
[project]
name = "example-project"
version = "0.1.0"
requires-python = ">=3.13"
dependencies = [
    "numpy>=2.2.6",
    "scipy>=1.15.2",
    "mkl-service>=2.4.2; sys_platform != 'darwin'",
]

[tool.uv.sources]
numpy = [{ index = "numpy-mkl", marker = "sys_platform != 'darwin'" }]
scipy = [{ index = "numpy-mkl", marker = "sys_platform != 'darwin'" }]
mkl-service = [{ index = "numpy-mkl", marker = "sys_platform != 'darwin'" }]

[[tool.uv.index]]
name = "numpy-mkl"
url = "https://urob.github.io/numpy-mkl"
explicit = true
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

All binaries are dynamically linked against the MKL library. The packages are patched to detect the
library at runtime as long as `mkl` is installed _anywhere_ accessible by Python. (This is indeed
the case when using one of the recommended install methods above, which will automatically install
`mkl` alongside NumPy or SciPy.)

## References

- [Intel(r) oneMKL Release
  Notes](https://www.intel.com/content/www/us/en/developer/articles/release-notes/onemkl-release-notes.html)
- [Intel(r) oneAPI Release
  Notes](https://www.intel.com/content/www/us/en/developer/articles/release-notes/intel-oneapi-toolkit-release-notes.html)

[^1]:
    More sophisticated checks can be added by combining with the `platform_machine` marker. In
    practices, distinguishing between macOS and other systems seems to be good enough for most use
    cases.
