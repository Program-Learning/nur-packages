# MIT
# # Using it:
#
# let
#   appimagelauncher = (pkgs.libsForQt5.callPackage ./somewhere/appimagelauncher-deb.nix {});
# in
# {
#   environment.systemPackages = with pkgs; [ appimagelauncher ];
#
#   systemd.user.services.appimage-launcherd = {
#     description = "AppImage Launcher";
#     wantedBy = [ "appimage-launcherd.target" ];
#     serviceConfig = {
#       Type = "simple";
#       ExecStart = "${appimagelauncher}/bin/appimagelauncherd";
#     };
#   };
# }
{
  fetchurl,
  lib,
  stdenv,
  dpkg,
  autoPatchelfHook,
  glib,
  qtbase,
  wrapQtAppsHook,
  librsvg,
  cairo,
  curlFull,
  libsForQt5,
}: let
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb";
    sha256 = "sha256:0zqaqxalb3zwmcqd5z5k1im9yslq29v1a52b0y8x0zdslrbdpfgl";
  };
in
  stdenv.mkDerivation {
    name = "appimagelauncher-${version}";

    system = "x86_64-linux";

    inherit src;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      wrapQtAppsHook
    ];

    buildInputs = [
      glib
      qtbase
      librsvg
      cairo
      curlFull
      libsForQt5.qt5.qtwayland
    ];

    unpackPhase = ''
      mkdir -p $out
      dpkg -x $src $out
    '';

    # Extract and copy executable in $out/bin
    installPhase = ''
      runHook preInstall

      mv $out/usr/{lib,share} $out
      mkdir $out/bin
      ln -s $out/usr/bin/{ail-cli,appimagelauncherd,AppImageLauncherSettings} $out/bin

      runHook postInstall
    '';

    meta = with lib; {
      description = "appimagelauncher";
      homepage = "https://github.com/TheAssassin/AppImageLauncher";
      license = licenses.mit;
      maintainers = [ ];
      platforms = ["x86_64-linux"];
    };
  }
# https://gist.github.com/socherbyc/019dba5281023b2c2b4329975a1dc655

