{
  description = "onjin's Neovim config";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.writeShellApplication {
            name = "onjin-nvim";
            runtimeInputs = with pkgs; [
              neovim
              git
              ripgrep
              gnumake
              tree-sitter
              stdenv.cc
            ];
            text = ''
              export NVIM_APPNAME="''${NVIM_APPNAME:-nvim-onjin}"
              config_root="''${XDG_CONFIG_HOME:-$HOME/.config}/$NVIM_APPNAME"
              ts_config_dir="$config_root/tree-sitter"
              ts_config_file="$ts_config_dir/config.json"

              mkdir -p "$ts_config_dir"

              if [ ! -f "$ts_config_file" ]; then
                tree-sitter init-config >/dev/null
              fi

              exec nvim -u ${./init_compact.lua} "$@"
            '';
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/onjin-nvim";
        };
      });
    };
}
