{ fetchurl, lib, stdenv, pkgs, appimage-run, makeDesktopItem }:
stdenv.mkDerivation rec {
  pname = "wechat_dev_tools";
  version = "1.06.2307260-1";

  src = fetchurl {
    url =
      "https://github.com/msojocs/wechat-web-devtools-linux/releases/download/v${version}/WeChat_Dev_Tools_v${version}_x86_64_linux.AppImage";
    sha256 = "sha256-rCDmoDEJlSKIJ8mECGGqMopgC4yAXnhv3ntc/KPULGU=";
  };
  sourceRoot = ".";

  nativeBuildInputs = with pkgs; [
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  unpackPhase = "echo";

  installPhase = ''
    _package-ide() {
      mkdir -p $out/Appimage
      ln -s $src $out/Appimage/wechat_dev_tools.AppImage
    }
    _package-ide
  '';

  buildInputs = with pkgs; [ ];

  #   runtimeLibs = pkgs.lib.makeLibraryPath [
  #   pkgs.libudev0-shim
  #   pkgs.glibc
  #   pkgs.libsecret
  #   pkgs.nss
  # ];

  preFixup = ''
    makeWrapper ${appimage-run}/bin/appimage-run $out/bin/wechat_dev_tools \
      --argv0 "wechat_dev_tools" \
      --add-flags "$out/Appimage/wechat_dev_tools.AppImage"
  '';

  # wechat_dev_tools-desktop =
  #   pkgs.writeText "share/applications/wechat_dev_tools-desktop.desktop" ''
  #     [Desktop Entry]
  #     Name=WeChat Dev Tools
  #     Name[zh_CN]=微信开发者工具
  #     Comment=The development tools for wechat projects
  #     Comment[zh_CN]=提供微信开发相关项目的开发IDE支持
  #     Categories=Development;WebDevelopment;IDE;
  #     Exec=${appimage-run}/bin/appimage-run $out/bin/wechat_dev_tools
  #     Icon=wechat-devtools
  #     Type=Application
  #     Terminal=false
  #     StartupWMClass=wechat_devtools
  #     Actions=
  #     MimeType=x-scheme-handler/wechatide
  #     X-AppImage-Version=v$version

  #   '';
  command = "${appimage-run}/bin/appimage-run ${out}/bin/wechat_dev_tools";
  desktopItems = lib.toList (makeDesktopItem {
    name = "Wechat Dev Tools";
    genericName = "The development tools for wechat projects";
    exec = command;
    icon = "wechat-devtools";
    comment = "The development tools for wechat projects";
    mimeTypes = [ "x-scheme-handler/wechatide" ];
    desktopName = "Wechat Dev Tools";
    categories = [ "Development" "WebDevelopment" "IDE" ];
    startupWMClass = "wechat_devtools";
  });
  meta = with lib; {
    description = "Wechat Dev Tools";
    homepage = "https://github.com/msojocs/wechat-web-devtools-linux";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Program-Learning ];
  };
}
