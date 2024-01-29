#https://github.com/Prismwork/llqqnt-nix/blob/trunk/pkgs/llqqnt.nix
{pkgs, ...}: let
  LiteLoaderQQNT_VERSION = "1.0.2";
  LiteLoaderQQNT_REV = "e570e4b250edfa00aced5149ddf0ee8692cb0d0a";
  LiteLoaderQQNT_URL = "https://github.com/LiteLoaderQQNT/LiteLoaderQQNT";
  LiteLoaderQQNT_SRC = fetchGit {
    url = LiteLoaderQQNT_URL;
    rev = LiteLoaderQQNT_REV;
    submodules = true;
  };
  fhs =
    # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSUserEnv (base
          // {
            name = "fhs";
            targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = ["dev"];
          })
    );
in
  pkgs.qq.overrideAttrs (oldAttrs @ {
    nativeBuildInputs ? [],
    version,
    ...
  }: {
    nativeBuildInputs =
      nativeBuildInputs
      ++ [
        fhs
      ];
    postInstall = ''
      # Patch QQ
      sed -i "1s@^@require(\"${LiteLoaderQQNT_SRC}\");\n@" $out/opt/QQ/resources/app/app_launcher/index.js
      mkdir -vp $out/opt/QQ/resources/app/application/
      cp -f ${LiteLoaderQQNT_SRC}/src/preload.js $out/opt/QQ/resources/app/application/
      # Use FHS environment run Patched QQ
      sed -i "s@^Exec=.*@Exec=${fhs}/bin/fhs -c 'LITELOADERQQNT_PROFILE=~/.local/share/LLQQNT $out/bin/qq %U'@g" $out/share/applications/qq.desktop
    '';
  })
