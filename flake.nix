{
  description = "MKL-accelerated NumPy and SciPy derivations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };
      inherit (pkgs) lib;
      inherit (import ./nix/lib.nix { inherit lib; }) supportedPythons;

      # Newest python that both has wheels and is provided by nixpkgs. Removed
      # interpreters linger as throwing aliases, so probe the attribute rather
      # than trust its name.
      attrFor = version: "python" + lib.replaceStrings [ "." ] [ "" ] version;
      provided =
        version:
        pkgs ? ${attrFor version} && (builtins.tryEval pkgs.${attrFor version}.pythonVersion).success;
      python = pkgs.${attrFor (lib.last (builtins.filter provided supportedPythons))};
    in
    {
      overlays.default = import ./nix/overlay.nix;

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [
          (python.withPackages (ps: [
            ps.numpy
            ps.scipy
          ]))
        ];
      };

      templates.default = {
        path = ./templates/nix;
        description = "MKL-accelerated Python environment with NumPy and SciPy";
      };
    };
}
