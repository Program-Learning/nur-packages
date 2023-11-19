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
    sha256 = "sha256-HMj73tYcQbrfeezx/aN3PH5YRaAFkzym7Vr9o74bmsI=";
  };
in
  pkgs.qq.overrideAttrs (oldAttrs @ {nativeBuildInputs ? [], ...}: {
    version = "3.2.0-16449";
    _hash = "464d27bd";
    pname = "llqqnt";

    nativeBuildInputs = nativeBuildInputs ++ [pkgs.p7zip];

    postInstall = ''
      mkdir $out/opt/QQ/resources/app/LiteLoader
      7z x ${LiteLoaderQQNT_SRC} -o$out/opt/QQ/resources/app/LiteLoader -y
      sed -i 's/"main": ".\/app_launcher\/index.js"/"main": ".\/LiteLoader"/' $out/opt/QQ/resources/app/package.json
    '';
  })
