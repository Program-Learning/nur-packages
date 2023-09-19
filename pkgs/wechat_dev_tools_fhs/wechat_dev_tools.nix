{ fetchurl, lib, stdenv, pkgs, }:
stdenv.mkDerivation rec {
  pname = "wechat_dev_tools";
  version = "1.06.2307260-1";

  src = fetchurl {
    url =
      "https://github.com/msojocs/wechat-web-devtools-linux/releases/download/v${version}/io.github.msojocs.wechat-devtools-linux_${version}_amd64.deb";
    sha256 = "sha256-lwjGqUBNmJRhF+mEI2Skd5tOPWkvzP3gOwJGr8m/LBw=";
  };
  sourceRoot = ".";

  nativeBuildInputs = with pkgs; [
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  unpackPhase =
    "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  installPhase = ''
    _package-ide() {
      mkdir -p $out/{bin,share/wechat_devtools,lib}

      mv opt/apps/io.github.msojocs.wechat-devtools-linux $out/share/wechat_devtools
      mv usr/share/* $out/share/

      substituteInPlace $out/share/applications/io.github.msojocs.wechat-devtools-linux.desktop  \
        --replace "/opt/apps/io.github.msojocs.wechat-devtools-linux" "$out/share/wechat_devtools" 
    }
    _package-ide
  '';

  # libraries = [ libdrm nspr alsaLib ];
  libraries = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    e2fsprogs
    gdk-pixbuf
    glib
    gnutls
    graphite2
    gtk2
    krb5
    libdrm
    libgcrypt
    libGLU
    libpulseaudio
    libthai
    libxkbcommon
    mesa_drivers
    nspr
    nss
    openldap
    rtmpdump
    udev
    util-linux
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXmu
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXt
    xorg.libXtst
  ];

  buildInputs = libraries;

  #   runtimeLibs = pkgs.lib.makeLibraryPath [
  #   pkgs.libudev0-shim
  #   pkgs.glibc
  #   pkgs.libsecret
  #   pkgs.nss
  # ];

  # preFixup = ''
  #   makeWrapper $out/share/feishu/feishu $out/bin/feishu \
  #     --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
  #     "''${gappsWrapperArgs[@]}"
  # '';

  meta = with lib; {
    description = "Wechat Dev Tools";
    homepage = "https://github.com/msojocs/wechat-web-devtools-linux";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Program-Learning ];
  };
}
