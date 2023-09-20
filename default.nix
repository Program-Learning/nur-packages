# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # example-package = pkgs.callPackage ./pkgs/example-package { };
  wechat_dev_tools_fhs_appimage =
    pkgs.callPackage ./pkgs/wechat_dev_tools_fhs_appimage { };
  wechat_dev_tools_fhs_deb =
    pkgs.callPackage ./pkgs/wechat_dev_tools_fhs_deb { };
  # wechat_dev_tools_appimage =
  #   pkgs.callPackage ./pkgs/wechat_dev_tools_appimage { };
  # wechat_dev_tools_deb =
  #   pkgs.callPackage ./pkgs/wechat_dev_tools_deb { };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
