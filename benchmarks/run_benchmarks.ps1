$env:UV_PYTHON = "cp312"

$tmp = [System.IO.Path]::GetTempPath()
$VENV_DIR = "$tmp\testenv"

# numpy-mkl
uv venv $VENV_DIR
. "$VENV_DIR\Scripts\activate.ps1"
uv pip install numpy scipy --index https://urob.github.io/numpy-mkl
python "$PSScriptRoot\benchmarks.py"
deactivate
Remove-Item -Path $VENV_DIR -Recurse -Force

## numpy-openblas
uv venv $VENV_DIR
. "$VENV_DIR\Scripts\activate.ps1"
uv pip install numpy scipy
python "$PSScriptRoot\benchmarks.py"
deactivate
Remove-Item -Path $VENV_DIR -Recurse -Force

# numpy-mkl-wheels
$url = "https://github.com/cgohlke/numpy-mkl-wheels/releases/latest/download"
$suffix = "$env:UV_PYTHON-$env:UV_PYTHON-win_amd64.whl"
curl.exe -fLO "${url}/mkl_service-2.4.2-${suffix}" --output-dir $tmp
curl.exe -fLO "${url}/numpy-2.2.4-${suffix}" --output-dir $tmp
curl.exe -fLO "${url}/scipy-1.15.2-${suffix}" --output-dir $tmp
uv venv $VENV_DIR
. "$VENV_DIR\Scripts\activate.ps1"
uv pip install "$tmp\mkl_service-2.4.2-${suffix}" "$tmp\numpy-2.2.4-${suffix}" "$tmp\scipy-1.15.2-${suffix}"
python "$PSScriptRoot\benchmarks.py"
deactivate
Remove-Item -Path $VENV_DIR -Recurse -Force

# conda-forge
New-Item -ItemType Directory -Path $VENV_DIR; Push-Location $VENV_DIR
pixi init -c conda-forge
pixi add numpy scipy "libblas=*=*mkl" "liblapack=*=*mkl"
pixi run python "$PSScriptRoot\benchmarks.py"
Pop-Location
Remove-Item -Path $VENV_DIR -Recurse -Force

# anaconda
New-Item -ItemType Directory -Path $VENV_DIR; Push-Location $VENV_DIR
pixi init -c anaconda
pixi add numpy scipy
pixi run python "$PSScriptRoot\benchmarks.py"
Pop-Location
Remove-Item -Path $VENV_DIR -Recurse -Force
