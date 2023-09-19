{ lib, buildFHSEnvChroot, xkeyboard_config, callPackage, }:
let wechat_dev_tools = callPackage ./wechat_dev_tools.nix { };
in buildFHSEnvChroot {
  name = "wechat_dev_tools-env";
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
      curl
      nss
      libdrm
      nspr
      alsaLib
      xorg.libxkbfile
      krb5
      mesa
      xorg.libxshmfence
    ];
  profile = ''
    export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/etc/X11/xkb"
    export FHS=1

    wechat-devtools
  '';
}
