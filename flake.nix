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
          cfg = config.boot.plymouth.win98se.label;
          boot_label =
            {
              release = config.system.nixos.release;
              none = "";
              custom = cfg.text;
            }
            .${cfg.mode};
          theme = pkgs.callPackage ./default.nix { inherit boot_label; };
        in
        {
          options.boot.plymouth.win98se.label = {
            mode = lib.mkOption {
              type = lib.types.enum [
                "release"
                "none"
                "custom"
              ];
              default = "release";
              description = "Selects the text below the NixOS logo.";
            };

            text = lib.mkOption {
              type = lib.types.str;
              default = "Unstable";
              description = "Sets the label when mode is custom.";
            };
          };

          config.boot.plymouth = {
            enable = true;
            theme = "win98se-nixos";
            themePackages = [ theme ];
          };
        };
    };
}
