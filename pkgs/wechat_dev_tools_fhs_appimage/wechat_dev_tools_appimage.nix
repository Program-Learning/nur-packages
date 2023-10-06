{ fetchurl, lib, stdenv, pkgs, appimage-run, makeDesktopItem }:
stdenv.mkDerivation rec {
  pname = "wechat_dev_tools";
  version = "1.06.2308310-1";

  src = fetchurl {
    url =
      "https://github.com/msojocs/wechat-web-devtools-linux/releases/download/v${version}/WeChat_Dev_Tools_v${version}_x86_64_linux.AppImage";
    sha256 = "sha256-XFKLfHHFQdErEDU7z/q/LomTNjxVreCDqNHX00we0GI=";
  };

  dontUnpack = true;

  icon = fetchurl {
    url =
      "https://github.com/Program-Learning/nur-packages/releases/download/v1.06.2307260-1_wechat_dev_tool_appimage/wechat-devtools.png";
    sha256 = "sha256-E1hGcnTtHN3tH/dYI/iN86osKzEV3fVATWquql2KbZQ=";
  };

  buildInputs = with pkgs; [ ];
  nativeBuildInputs = with pkgs; [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall
    _install() {
      mkdir -p $out/{bin,lib/wechat_dev_tools}
      ln -s $src $out/lib/wechat_dev_tools/wechat_dev_tools.AppImage
      install -Dm644 $icon $out/share/icons/hicolor/48x48/apps/wechat_dev_tools.png
      makeWrapper ${appimage-run}/bin/appimage-run $out/bin/wechat_dev_tools \
      --argv0 "wechat_dev_tools" \
      --add-flags "$out/lib/wechat_dev_tools/wechat_dev_tools.AppImage"
    }
    _install
    runHook postInstall
  '';

  desktopItems = lib.toList (makeDesktopItem {
    name = "Wechat Dev Tools";
    genericName = "The development tools for wechat projects";
    exec = "wechat_dev_tools";
    icon = "wechat_dev_tools";
    comment = "The development tools for wechat projects";
    mimeTypes = [ "x-scheme-handler/wechatide" ];
    desktopName = "Wechat Dev Tools";
    categories = [ "Development" "WebDevelopment" "IDE" ];
    startupWMClass = "wechat_devtools";
  });
  
  meta = with lib; {
    description = "Wechat Dev Tools";
    homepage = "https://github.com/msojocs/wechat-web-devtools-linux";
    # license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Program-Learning ];
  };
}
