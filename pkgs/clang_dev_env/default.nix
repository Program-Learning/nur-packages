{ buildFHSEnvChroot, ... }:
buildFHSEnvChroot {
  name = "clang_dev-env";
  targetPkgs = pkgs:
    with pkgs; [
      clang-tools
      ccls
      llvmPackages.clang # c/c++ tools with clang-tools such as clangd
    ];
  profile = ''
    export FHS=1
  '';
}
