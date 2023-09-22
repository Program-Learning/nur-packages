{ fetchurl, lib, stdenv, pkgs, appimage-run, makeDesktopItem }:
stdenv.mkDerivation rec {
  pname = "Adobe_Photoshop_CS6";
  version = "CS6";

  src = fetchurl {
    url =
      "https://github.com/Program-Learning/nur-packages/releases/download/Adobe_Photoshop_CS6.AppImage/Adobe_Photoshop_CS6.AppImage.7z";
    sha256 = "sha256-U19wx0asTuu6o/AvUrp2AM1bywwJAfH5R7H4zdVPj+A=";
  };
  sourceRoot = ".";

  nativeBuildInputs = with pkgs; [
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  unpackPhase = "7z x $src";

  installPhase = ''
    _install() {
      mkdir -p $out/Appimage
      mv Adobe_Photoshop_CS6.AppImage $out/Appimage/
    }
    _install
  '';

  buildInputs = with pkgs; [ p7zip ];

  #   runtimeLibs = pkgs.lib.makeLibraryPath [
  #   pkgs.libudev0-shim
  #   pkgs.glibc
  #   pkgs.libsecret
  #   pkgs.nss
  # ];

  preFixup = ''
    makeWrapper ${appimage-run}/bin/appimage-run $out/bin/photoshop \
      --argv0 "photoshop" \
      --add-flags "$out/Appimage/Adobe_Photoshop_CS6.AppImage"
  '';

  desktopItems = lib.toList (makeDesktopItem {
    name = "adobe_Photoshop_CS6";
    genericName = "Adobe_Photoshop_CS6";
    exec = "photoshop";
    icon = "photoshop";
    comment = "Adobe_Photoshop_CS6";
    mimeTypes = [ "x-scheme-handler/wechatide" ];
    desktopName = "Adobe_Photoshop_CS6";
    categories = [ "Development" ];
    # startupWMClass = "wechat_devtools";
  });
  meta = with lib; {
    description = "Adobe_Photoshop_CS6";
    homepage = "https://t.me/Linux_Appimages/1042";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Program-Learning ];
  };
}
