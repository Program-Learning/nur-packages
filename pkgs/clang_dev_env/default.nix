{ pkgs, ... }:
buildEnv {
  name = "clang_dev_env";
  targetPkgs = pkgs:
    with pkgs; [
      clang-tools
      ccls
      llvmPackages.clang # c/c++ tools with clang-tools such as clangd
    ];
  profile = ''
  '';
}
