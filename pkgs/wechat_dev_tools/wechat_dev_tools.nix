{
  fetchurl,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "wechat_dev_tools";
  version = "1.06.2307260-1";

  src = fetchurl {
    url = "https://github.com/msojocs/wechat-web-devtools-linux/releases/download/v${version}/io.github.msojocs.wechat-devtools-linux_${version}_amd64.deb";
    sha256 = "sha256-FpbJ+IDGkqA6cjn9RMCda2wJf4a+RhWI/JO1X+MW1cg=";
  };
  sourceRoot = ".";

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

  meta = with lib; {
    description = "Wechat Dev Tools";
    homepage = "https://github.com/msojocs/wechat-web-devtools-linux";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
    maintainers = with maintainers; [Program-Learning];
  };
}