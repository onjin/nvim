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
              export ONJIN_NVIM_HOME="''${ONJIN_NVIM_HOME:-$HOME/.local/share/onjin-nvim}"
              export XDG_CONFIG_HOME="$ONJIN_NVIM_HOME/config"
              export XDG_DATA_HOME="$ONJIN_NVIM_HOME/data"
              export XDG_STATE_HOME="$ONJIN_NVIM_HOME/state"
              export XDG_CACHE_HOME="$ONJIN_NVIM_HOME/cache"

              config_root="$XDG_CONFIG_HOME"
              ts_config_dir="$config_root/tree-sitter"
              ts_config_file="$ts_config_dir/config.json"
              ts_parser_dir="$ONJIN_NVIM_HOME/tree-sitter-parsers"

              mkdir -p "$ts_config_dir" "$ts_parser_dir" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"

              if [ ! -f "$ts_config_file" ]; then
                printf '{\n  "parser-directories": [\n    "%s"\n  ]\n}\n' "$ts_parser_dir" >"$ts_config_file"
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
