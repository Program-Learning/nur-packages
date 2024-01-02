{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  fetchgit,
  clickgen,
  attrs,
}:
stdenvNoCC.mkDerivation rec {
  pname = "xcursor-genshin-nahida";
  version = "1.0-2";

  src = fetchgit {
    url = "https://aur.archlinux.org/xcursor-genshin-nahida.git";
    rev = "3a6d21a337925f47466c74d16c413e7be6ee58e4";
    hash = "";
  };

  installPhase = ''
    tar -xf xcursor-genshin-nahida.tar.gz --directory=$out
  '';

  meta = with lib; {
    description = "xcursor genshin nahida";
    homepage = "https://aur.archlinux.org/packages/xcursor-genshin-nahida";
    license = licenses.gpl;
    # maintainers = with maintainers; [ Program-Learning ];
    platforms = platforms.linux;
  };
}
