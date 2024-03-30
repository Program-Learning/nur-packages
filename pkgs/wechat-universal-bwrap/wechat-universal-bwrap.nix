{
  pkgs,
  lib,
  fetchurl,
  fetchgit,
  stdenv,
}: let
  sources = import ./sources.nix;
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.tencent.wechat/com.tencent.wechat_${sources.version}_amd64.deb";
      sha256 = sources.amd64_sha256;
    };
    aarch64-linux = fetchurl {
      url = "https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.tencent.wechat/com.tencent.wechat_${sources.version}_arm64.deb";
      sha256 = sources.arm64_sha256;
    };
    loongarch64-linux = fetchurl {
      url = "https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.tencent.wechat/com.tencent.wechat_${sources.version}_loongarch64.deb";
      sha256 = sources.loongarch64_sha256;
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  aur = fetchgit {
    url = "https://gitee.com/MayuriNFC/wechat-universal-bwrap.git";
    sha256 = "sha256-VWWDrsdT84I6WGUba8jb6CuPPtqfomGGcwQvTBsNgkg=";
    #sha256 = "";
  };
  _pkgname = "wechat-universal";
  pname = "${_pkgname}-bwrap";
  desktop = import "${aur}/wechat-universal.desktop.nix" pkgs;
  startScript = import "${aur}/wechat-universal.sh.nix" pkgs;
  fake_dde-file-manager = import "${aur}/fake_dde-file-manager.nix" pkgs;
in
  stdenv.mkDerivation rec {
    inherit pname;
    inherit (sources) version;
    inherit src;
    dontUnpack = true;

    nativeBuildInputs = [pkgs.libarchive pkgs.gcc];

    buildInputs = [
      pkgs.killall
      pkgs.bzip2
      pkgs.alsaLib
      pkgs.at-spi2-core

      # flatpakXdgUtils
      pkgs.xdg-utils

      # libXcomposite
      pkgs.xorg.libXcomposite

      pkgs.bubblewrap

      # pkgs.libXkbcommonX11
      pkgs.libxkbcommon
      # pkgs.libXrandr
      pkgs.xorg.libXrandr

      pkgs.mesa
      pkgs.nss
      pkgs.pango

      # pkgs.xcbUtilImage
      pkgs.xorg.xcbutilimage

      # pkgs.xcbUtilKeysyms
      pkgs.xorg.xcbutilkeysyms

      # pkgs.xcbUtilRenderutil
      pkgs.xorg.xcbutilrenderutil

      # pkgs.xcbUtilWm
      pkgs.xorg.xcbutilwm

      # pkgs.xdgDesktopPortal
      pkgs.xdg-desktop-portal

      # pkgs.xdgUserDirs
      pkgs.xdg-user-dirs
    ];

    installPhase = ''
      export _lib_uos='libuosdevicea'
      export _wechat_root="$out/usr/share/${_pkgname}"
      mkdir $out
      mkdir $out/bin
      bsdtar -xOf ${src} ./data.tar.xz |
          xz -cdT0 |
          bsdtar -xpC $out ./opt/apps/com.tencent.wechat
      mv $out/opt/{apps/com.tencent.wechat/files,${_pkgname}}
      rm $out/opt/${_pkgname}/$_lib_uos.so

      for res in 16 32 48 64 128 256; do
          install -Dm644 \
              $out/opt/apps/com.tencent.wechat/entries/icons/hicolor/''${res}x''${res}/apps/com.tencent.wechat.png \
              $out/usr/share/icons/hicolor/''${res}x''${res}/apps/${_pkgname}.png
      done
      rm -rf $out/opt/apps

      install -dm755 $out/usr/lib/license
      gcc -fPIC -shared "${aur}/''${_lib_uos}.c" -o "''${_lib_uos}.so"
      install -Dm755 $_lib_uos.so $_wechat_root/usr/lib/license/$_lib_uos.so
      echo 'DISTRIB_ID=uos' | install -Dm755 /dev/stdin $_wechat_root/etc/lsb-release

      install -Dm755 ${fake_dde-file-manager}/bin/fake-dde-file-manager $_wechat_root/usr/bin/dde-file-manager
      install -Dm644 ${desktop} $out/usr/share/applications/${_pkgname}.desktop
      install -Dm755 ${startScript}/bin/wechat-universal $out/usr/bin/${_pkgname}
      install -Dm755 ${startScript}/bin/wechat-universal $out/bin/${_pkgname}
      sed -i "s@OutputPath@$out@g" $out/usr/bin/${_pkgname}
      sed -i "s@OutputPath@$out@g" $out/bin/${_pkgname}
    '';
    postInstall = ''
      '';

    meta = with lib; {
      description = "WeChat (Universal) with bwrap sandbox";
      license = licenses.unfree;
      platforms = platforms.linux;
      broken = true;
    };
  }
