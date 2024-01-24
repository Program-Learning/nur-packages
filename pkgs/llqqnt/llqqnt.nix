#https://github.com/Prismwork/llqqnt-nix/blob/trunk/pkgs/llqqnt.nix
{
  pkgs,
  fetchurl,
  fetchgit,
  ...
}: let
  LiteLoaderQQNT_VERSION = "1.0.2";
  LiteLoaderQQNT_URL = "https://github.com/LiteLoaderQQNT/LiteLoaderQQNT";
  LiteLoaderQQNT_SRC = fetchgit {
    url = LiteLoaderQQNT_URL;
    sha256 = "sha256-4pWXd/C3Fgh0kQjHOdN1Dce82d9WQN7r/21M0W+JE5Y=";
  };
in
  pkgs.qq.overrideAttrs (oldAttrs @ {nativeBuildInputs ? [],version, ...}: {
    nativeBuildInputs = nativeBuildInputs ++ [pkgs.p7zip];

    postInstall = ''
      sed -i '1s@^@require("${LiteLoaderQQNT_SRC}");\n@' $out/opt/QQ/resources/app/app_launcher/index.js
      mkdir -vp $out/opt/QQ/resources/app/application/
      cp -f ${LiteLoaderQQNT_SRC}/src/preload.js $out/opt/QQ/resources/app/application/
    '';
  })
