{
  description = "Win98SE-inspired Plymouth theme for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
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
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          release_slug = lib.replaceStrings [ "." ] [ "-" ] config.system.nixos.release;
          versioned_boot_image = ./theme + "/boot-${release_slug}.png";
          boot_image =
            if builtins.pathExists versioned_boot_image then
              versioned_boot_image
            else
              ./theme/boot-unstable.png;
          theme = pkgs.callPackage ./default.nix { inherit boot_image; };
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
