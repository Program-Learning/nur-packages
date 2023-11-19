#https://github.com/Prismwork/llqqnt-nix/blob/trunk/pkgs/llqqnt.nix
{ pkgs, ... }:

let
  LiteLoaderQQNT_SRC = builtins.fetchGit {
    url = "https://github.com/LiteLoaderQQNT/LiteLoaderQQNT";
    rev = "4fad0cb92d6881438abfa0ffc2934689b6828dd3";
    submodules = true;
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
