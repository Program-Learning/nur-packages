{
  lib,
  buildFHSEnvChroot,
  freetype,
  xkeyboard_config,
  callPackage,
}: let
  wechat_dev_tools = callPackage ./wechat_dev_tools.nix {};
in
  buildFHSEnvChroot {
    name = "gowin-env";
    targetPkgs = pkgs:
      with pkgs; [
        wechat_dev_tools
        # runtime dependencies
        libGL
        fontconfig
        libxcrypt-legacy
        zlib
        libuuid
        libpulseaudio
        glib
        dbus
        libusb
      ];
    profile = ''
      export LD_PRELOAD="${lib.getLib freetype}/lib/libfreetype.so"
      export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/etc/X11/xkb"
      export FHS=1

      gw_ide
    '';
  }