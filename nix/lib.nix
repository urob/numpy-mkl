# Wheel table lookup shared by every derivation in this overlay.
{ lib }:
let
  wheels = import ./wheels.nix;
in
rec {
  # Python versions with a complete, internally consistent resolution.
  supportedPythons = builtins.sort lib.versionOlder (lib.attrNames wheels);

  # Select the wheel matching `python`, or fail with an actionable message.
  #
  # Keys on `pythonVersion` rather than `version`, as the latter reports the
  # implementation release rather than the language version (PyPy 3.11 calls
  # itself 7.3.20). Passing `abi = "cpython"` additionally rejects
  # interpreters whose ABI the wheel does not target, such as PyPy and
  # free-threaded builds, which would otherwise silently be handed a wheel
  # built for the default ABI of the same language version.
  wheelFor =
    {
      pname,
      python,
      abi ? "none",
    }:
    let
      inherit (python) pythonVersion;
      tag = "cp" + lib.replaceStrings [ "." ] [ "" ] pythonVersion;

      # Tolerate nixpkgs revisions predating pythonABITags.
      abiOk = abi != "cpython" || !(python ? pythonABITags) || lib.elem tag python.pythonABITags;

      resolution = wheels.${pythonVersion} or { };
    in
    if abiOk && resolution ? ${pname} then
      resolution.${pname}
    else
      throw ''
        numpy-mkl has no ${pname} wheel for ${python.executable} (python ${pythonVersion}).
        This overlay provides x86_64-linux CPython wheels for python ${lib.concatStringsSep ", " supportedPythons}.
        See https://github.com/urob/numpy-mkl for the supported versions.
      '';
}
