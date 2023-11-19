#https://github.com/Prismwork/llqqnt-nix/blob/trunk/pkgs/llqqnt.nix
{
  pkgs,
  fetchurl,
  ...
}: let
  # https://aur.archlinux.org/packages/liteloader-qqnt-bin
  LiteLoaderQQNT_VERSION = "0.5.9";
  LiteLoaderQQNT_SRC = fetchurl {
    url = "https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/${LiteLoaderQQNT_VERSION}/LiteLoaderQQNT.zip";
    sha256 = "";
  };
in
  pkgs.qq.overrideAttrs (oldAttrs: {
    pname = "llqqnt";

    postInstall = ''
      mkdir $out/opt/QQ/resources/app/LiteLoader
      cp -r ${LiteLoaderQQNT_SRC.outPath}/* $out/opt/QQ/resources/app/LiteLoader
      sed -i 's/"main": ".\/app_launcher\/index.js"/"main": ".\/LiteLoader"/' $out/opt/QQ/resources/app/package.json
    '';
  })
