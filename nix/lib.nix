# Wheel table lookup shared by every derivation in this overlay.
{ lib }:
let
  wheels = import ./wheels.nix;
in
rec {
  # Python versions with a complete, internally consistent resolution. Free-threaded
  # builds carry a "t" suffix (e.g. "3.15t") and sort right after their default build.
  supportedPythons = builtins.sort lib.versionOlder (lib.attrNames wheels);

  isFreeThreaded = version: lib.hasSuffix "t" version;

  # The nixpkgs attribute providing a python version: "3.15" -> python315, and
  # "3.15t" -> python315FreeThreading.
  attrFor =
    version:
    "python"
    + lib.replaceStrings [ "." ] [ "" ] (lib.removeSuffix "t" version)
    + lib.optionalString (isFreeThreaded version) "FreeThreading";

  # The wheels.nix key of an interpreter. `pythonVersion` reads "3.15" for both the
  # default and the free-threaded build, so tell them apart by the ABI tags, which
  # list cp315t instead of cp315 for the latter. Nixpkgs revisions predating
  # pythonABITags only have default builds.
  keyFor =
    python:
    let
      inherit (python) pythonVersion;
      ftTag = "cp" + lib.replaceStrings [ "." ] [ "" ] pythonVersion + "t";
    in
    pythonVersion
    + lib.optionalString (python ? pythonABITags && lib.elem ftTag python.pythonABITags) "t";

  # Select the wheel matching `python`, or fail with an actionable message.
  #
  # Every package, including the ABI-independent mkl runtime, is read from the
  # resolution of the interpreter's own key, so that an environment never mixes
  # wheels from the default and the free-threaded resolution.
  #
  # Keys on `pythonVersion` rather than `version`, as the latter reports the
  # implementation release rather than the language version (PyPy 3.11 calls
  # itself 7.3.20). Passing `abi = "cpython"` additionally rejects interpreters
  # whose ABI the wheel does not target, such as PyPy.
  wheelFor =
    {
      pname,
      python,
      abi ? "none",
    }:
    let
      key = keyFor python;
      tag = "cp" + lib.replaceStrings [ "." ] [ "" ] key;

      # Tolerate nixpkgs revisions predating pythonABITags.
      abiOk = abi != "cpython" || !(python ? pythonABITags) || lib.elem tag python.pythonABITags;

      resolution = wheels.${key} or { };
    in
    if abiOk && resolution ? ${pname} then
      resolution.${pname}
    else
      throw ''
        numpy-mkl has no ${pname} wheel for ${python.executable} (python ${key}).
        This overlay provides x86_64-linux CPython wheels for python ${lib.concatStringsSep ", " supportedPythons}
        (a "t" suffix denotes a free-threaded build, e.g. python315FreeThreading for 3.15t).
        See https://github.com/urob/numpy-mkl for the supported versions.
      '';
}
