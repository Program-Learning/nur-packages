{
  buildFHSEnvChroot,
  callPackage,
}: let
  llqqnt = callPackage ./llqqnt.nix {};
in
  buildFHSEnvChroot {
    name = "qq";
    targetPkgs = pkgs:
      with pkgs; [
        llqqnt
      ];
    profile = ''
      export FHS=1
      export  LITELOADERQQNT_PROFILE=$XDG_DATA_HOME/LLQQNT
      qq
    '';
  }
