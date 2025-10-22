Released on {date}.

### Latest builds

{latest}

### Usage

It is recommended to use `uv` or `pip` to automatically handle all dependencies.

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

**Manual installation**

Current wheels for all packages and versions can be [downloaded here](https://urob.github.io/numpy-mkl/). Attached below are *newly* built wheels only.

Manual installs must install compatible versions of `mkl`, `mkl-service`, and their indirect dependencies. For maximum compatibility, it is recommended to install `mkl-service` from this repository, which has been patched to automatically detect and load the `mkl` library whenever `numpy` or `scipy` are imported.

