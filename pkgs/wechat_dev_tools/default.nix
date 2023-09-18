{ stdenv,pkgs,lib }:

let 
  version = "1.06.2307260-continuous";
  pname = "io.github.msojocs.wechat-devtools-linux";
in
pkgs.stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  inherit version;

  meta = with lib; {
    description = "Wechat Dev Tools";
    homepage = "https://github.com/msojocs/wechat-web-devtools-linux";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
  };

  src = pkgs.fetchurl {
    url = "https://github.com/msojocs/wechat-web-devtools-linux/releases/download/continuous/io.github.msojocs.wechat-devtools-linux_1.06.2307260-continuous_amd64.deb";
    sha256 = "sha256-/1nhc5frfzzsp0wd84r1m6j0q0fdkasqxg3phj3hjc8ylxkwv8qir";
  };

  buildInputs = with pkgs; [
    git
  ];
  nativeBuildInputs = with pkgs; [
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
    dpkg
  ];
  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/wechat_devtools,lib}

    mv opt/apps/io.github.msojocs.wechat-devtools-linux $out/share/wechat_devtools
    mv usr/share/* $out/share/

    substituteInPlace $out/share/applications/io.github.msojocs.wechat-devtools-linux.desktop  \
      --replace "/opt/apps/io.github.msojocs.wechat-devtools-linux" "$out/share/wechat_devtools" 

    runHook postInstall
  '';

  dontWrapGApps = true;

  runtimeLibs = pkgs.lib.makeLibraryPath [
    pkgs.libudev0-shim
    pkgs.glibc
    pkgs.libsecret
    pkgs.nss
  ];

  # preFixup = ''
  #   makeWrapper $out/share/feishu/feishu $out/bin/feishu \
  #     --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
  #     "''${gappsWrapperArgs[@]}"
  # '';
  enableParallelBuilding = true;
}
