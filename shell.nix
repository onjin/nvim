{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = [pkgs.bashInteractive ];
  buildInputs = [ pkgs.git pkgs.neovim pkgs.stylua pkgs.selene pkgs.gnumake pkgs.luarocks ];

  shellHook = ''
    echo ""
  '';
}

