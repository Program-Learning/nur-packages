{ fetchurl, lib, stdenv, pkgs, appimage-run, makeDesktopItem }:
stdenv.mkDerivation rec {
  pname = "Adobe_Illustrator_CS6";
  version = "CS6";

  src = fetchurl {
    url =
      "https://github.com/Program-Learning/nur-packages/releases/download/Adobe_Illustrator_CS6.AppImage/Adobe_Illustrator_CS6.AppImage.7z";
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
      mv Adobe_Illustrator_CS6.AppImage $out/Appimage/
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
    makeWrapper ${appimage-run}/bin/appimage-run $out/bin/adobe_illustrator_cs6 \
      --argv0 "adobe_illustrator_cs6" \
      --add-flags "$out/Appimage/Adobe_Illustrator_CS6.AppImage"
  '';

  desktopItems = lib.toList (makeDesktopItem {
    name = "Adobe_Illustrator_CS6";
    genericName = "Adobe_Illustrator_CS6";
    exec = "illustrator";
    icon = "illustrator";
    comment = "Adobe_Illustrator_CS6";
    desktopName = "Adobe_Illustrator_CS6";
    categories = [ "Development" ];
  });
  meta = with lib; {
    description = "Adobe_Illustrator_CS6";
    homepage = "https://t.me/Linux_Appimages/1052";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Program-Learning ];
  };
}
