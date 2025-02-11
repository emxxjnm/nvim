{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = [
    pkgs.stylua
    pkgs.lua-language-server
  ];
}
