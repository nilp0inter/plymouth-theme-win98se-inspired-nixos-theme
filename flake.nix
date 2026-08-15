{
  description = "Win98SE-inspired Plymouth theme for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      for_all_systems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = for_all_systems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.callPackage ./default.nix { };
          win98se-nixos = self.packages.${system}.default;
        }
      );

      nixosModules.default =
        { pkgs, ... }:
        let
          theme = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
        in
        {
          boot.plymouth = {
            enable = true;
            theme = "win98se-nixos";
            themePackages = [ theme ];
          };
        };
    };
}
