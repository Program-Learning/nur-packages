# When you use pkgs.callPackage, parameters here will be filled with packages from Nixpkgs (if there's a match)
{ stdenv, fetchFromGitHub, cmake, gcc }@args:
let
  src = fetchFromGitHub ({
    owner = "Program-Learning";
    repo = "waybar-bluetooth_battery_parse";
    # Commit or tag, note that fetchFromGitHub cannot follow a branch!
    rev = "96209641f510ac06f157f5493893ba55ef2a4dc7";
    # Download git submodules, most packages don't need this
    fetchSubmodules = false;
    # Don't know how to calculate the SHA256 here? Comment it out and build the package
    # Nix will raise an error and show the correct hash
    sha256 = "sha256-hZ6gL5Iez2Ex8g10ROIGm7IYVxR2lLlu+/d+CbbjOEQ=";
  });
in stdenv.mkDerivation rec {
  # Specify package name and version
  pname = "waybar-bluetooth_battery_parse";
  version = "0.0.2";
  src = src;
  buildInputs = [ cmake ];

  # Download source code from GitHub

  # Parallel building, drastically speeds up packaging, enabled by default.
  # You only want to turn this off for one of the rare packages that fails with this.
  enableParallelBuilding = true;
  # If you encounter some weird error when packaging CMake-based software, try enabling this
  # This disables some automatic fixes applied to CMake-based software
  dontFixCmake = true;

  # Add CMake to the building environment, to generate Makefile with it
  nativeBuildInputs = [ cmake ];

  # Arguments to CMake that controls functionalities of liboqs
  cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=$out" ];

  # stdenv.mkDerivation automatically does the rest for you
}
