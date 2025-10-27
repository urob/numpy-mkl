{
  description = "MKL-accelerated NumPy and SciPy wheels";

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
    in
    {
      overlays.default = import ./nix/overlay.nix;

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [
          (pkgs.python314.withPackages (ps: [
            ps.numpy
            ps.scipy
          ]))
        ];
      };
    };
}
