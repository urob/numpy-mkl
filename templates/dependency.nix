# Do not edit, generated automatically by <maintain-nix-deps.py>.
{{
  buildPythonPackage,
  callPackage,
  fetchurl,
  lib,
}}:
buildPythonPackage rec {{
  pname = "{name}";
  version = "{version}";
  format = "wheel";

  src = fetchurl {{
    url = "{url}";
    hash = "{hash}";
  }};

  dependencies = [{dependencies}
  ];

  # Add dependency libraries to runtime path of mkl libs. Do this
  # postFixup as patchelf doesn't detect undeclared dependencies.
  postFixup = ''
    find $out \( -name '*.so' -o -name '*.so.*' \) -exec patchelf \
      --add-rpath ${{lib.makeLibraryPath dependencies}} {{}} \;
  '';

  doCheck = false;

  meta = {{
    description = "{description}";
    homepage = "{project_url}";
    license = "{license}";
  }};
}}
