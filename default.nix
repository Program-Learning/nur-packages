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
  Adobe_Photoshop_CS6_appimage =
    pkgs.callPackage ./pkgs/Adobe_Photoshop_CS6_appimage { };
  Adobe_Illustrator_CS6_appimage =
    pkgs.callPackage ./pkgs/Adobe_Illustrator_CS6_appimage { };
  wechat_dev_tools_appimage =
    pkgs.callPackage ./pkgs/wechat_dev_tools_appimage { };
  escrcpy_appimage =
    pkgs.callPackage ./pkgs/escrcpy_appimage { };
  wechat_dev_tools_deb = pkgs.callPackage ./pkgs/wechat_dev_tools_deb { };
  qtscrcpy = pkgs.libsForQt5.callPackage ./pkgs/qtscrcpy { };
  waybar-bluetooth_battery_parse =
    pkgs.callPackage ./pkgs/waybar-bluetooth_battery_parse { };
  llqqnt =
    pkgs.callPackage ./pkgs/llqqnt {};
  CrossOver = pkgs.callPackage ./pkgs/CrossOver {
    iUnderstandThatReplacingMoltenVKAndDXVKIsNotSupportedByCodeWeaversAndWillNotBotherThemForSupport =
      true;
  };
  xcursor-genshin-nahida = pkgs.callPackage ./pkgs/xcursor-genshin-nahida {};
  watt-toolkit_2 = pkgs.callPackage ./pkgs/watt-toolkit_2 { };
  clang_dev_env_fhs = pkgs.callPackage ./pkgs/clang_dev_env_fhs { };
  clang_dev_env = pkgs.callPackage ./pkgs/clang_dev_env { };
  AppimageLauncher = pkgs.libsForQt5.callPackage ./pkgs/AppimageLauncher { };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
