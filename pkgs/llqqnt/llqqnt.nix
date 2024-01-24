#https://github.com/Prismwork/llqqnt-nix/blob/trunk/pkgs/llqqnt.nix
{
  pkgs,
  ...
}: let
  LiteLoaderQQNT_VERSION = "1.0.2";
  LiteLoaderQQNT_REV = "f621aeef07b77aa037b46af00aee8055ffb006ef";
  LiteLoaderQQNT_URL = "https://github.com/LiteLoaderQQNT/LiteLoaderQQNT";
  LiteLoaderQQNT_SRC = fetchGit {
    url = LiteLoaderQQNT_URL;
    rev = LiteLoaderQQNT_REV;
    submodules = true;
  };
in
  pkgs.qq.overrideAttrs (oldAttrs @ {
    nativeBuildInputs ? [],
    version,
    ...
  }: {
    postInstall = ''
      sed -i '1s@^@require("${LiteLoaderQQNT_SRC}");\n@' $out/opt/QQ/resources/app/app_launcher/index.js
      mkdir -vp $out/opt/QQ/resources/app/application/
      cp -f ${LiteLoaderQQNT_SRC}/src/preload.js $out/opt/QQ/resources/app/application/
    '';
  })
