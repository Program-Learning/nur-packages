{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  qtx11extras,
  ffmpeg,
  wrapQtAppsHook,
  copyDesktopItems,
  android-tools,
  makeDesktopItem,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "qtscrcpy";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "barry-ran";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Yu39b+HBZh1QLZMsps6S7wYMokQ4H+ncENr/fdVs8s0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [cmake pkg-config wrapQtAppsHook copyDesktopItems];
  buildInputs = [qttools qtx11extras ffmpeg];

  postPatch = ''
    substituteInPlace ./QtScrcpy/main.cpp \
      --replace "../../../third_party/adb/linux/adb" "${android-tools.out}/bin/adb" \
      --replace "../../../third_party/scrcpy-server" "$out/scrcpy-server"
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp ../output/linux/release/QtScrcpy $out/bin/
    cp ${src}/third_party/scrcpy-server $out/
    mkdir -p $out/share/pixmaps/
    cp ${src}/backup/logo.png $out/share/pixmaps/${pname}.png
    runHook postInstall
  '';

  # https://aur.archlinux.org/cgit/aur.git/tree/qtscrcpy.desktop?h=qtscrcpy
  desktopItems = lib.toList (makeDesktopItem {
    name = pname;
    type = "Application";
    icon = pname;
    desktopName = "QtScrcpy";
    exec = "QtScrcpy";
    terminal = false;
    categories = ["Development" "Utility"];
    comment = "Android real-time screencast control tool";
  });

  meta = with lib; {
    description = "Android real-time display control software";
    homepage = "https://github.com/barry-ran/QtScrcpy";
    license = licenses.asl20;
    # maintainers = with maintainers; [ Program-Learning ];
    platforms = platforms.linux;
    broken = true;
  };
}
# https://github.com/NixOS/nixpkgs/commit/d896f0d8e02d3a251e595761807eb9656a221685

