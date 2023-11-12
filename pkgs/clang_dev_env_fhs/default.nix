{ buildFHSEnvChroot, ... }:
buildFHSEnvChroot {
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
}
