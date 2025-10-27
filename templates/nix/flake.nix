{
  description = "MKL-accelerated Python environment with NumPy and SciPy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mkl-overlay.url = "github:urob/numpy-mkl";
  };

  outputs =
    { nixpkgs, mkl-overlay, ... }:
    let
      system = "x86_64-linux";
      overlays = [ mkl-overlay.overlays.default ];
      pkgs = import nixpkgs { inherit system overlays; };

      # Select python version here, or set to python3 for default.
      python = with pkgs; python314;
    in
    {
      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [
          (python.withPackages (ps: [
            # Add mkl-accelerated NumPy and SciPy to Python environment.
            ps.numpy
            ps.scipy

            # Add other Python packages here. E.g.,
            # ps.matplotlib
            # ps.pandas
          ]))

          # Add other Nix packages here. E.g.,
          # pkgs.ruff
        ];
      };
    };
}
