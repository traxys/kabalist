{ pkgs ? import <nixpkgs> { } }:
let
  vue_cli = import "/home/traxys/softs/vue-cli/packages/@vue/cli/default.nix" { };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs.nodePackages; [
    vue_cli.package
    vls
    prettier
    eslint
	npm
  ];
}
