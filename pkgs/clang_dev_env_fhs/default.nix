{pkgs ? import <nixpkgs> {}}: let
  fhs = pkgs.buildFHSEnvChroot {
    name = "clang_dev_env_fhs";
    targetPkgs = pkgs:
      with pkgs; [
        clang-tools
        ccls
        llvmPackages.clang # c/c++ tools with clang-tools such as clangd
      ];
    profile = ''
      export FHS=1
    '';
  };
in
  pkgs.stdenv.mkDerivation {
    name = "clang_dev_env_fhs-shell";
    nativeBuildInputs = [fhs];
    shellHook = "exec clang_dev_env_fhs";
  }
