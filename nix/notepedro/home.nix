{ inputs, user, pkgs, my-overlays, ... }:
let
  android-wayland = pkgs.runCommand "android-studio-wayland" { buildInputs = [ pkgs.makeWrapper ]; } ''
      makeWrapper ${pkgs.android-studio}/bin/android-studio $out/bin/android-studio-wayland --set QT_QPA_PLATFORM xcb
  '';
  # microsoft-edge = pkgs.symlinkJoin {
  #       name = "microsoft-edge";
  #       paths = [ pkgs.microsoft-edge ];
  #       buildInputs = [ pkgs.makeWrapper ];
  #       postBuild = ''
  #         wrapProgram $out/bin/microsoft-edge --add-flags '--enable-features=UseOzonePlatform --ozone-platform=wayland --ozone-platform-hint=wayland --gtk-version=4 --ignore-gpu-blocklist'
  #       '';
  #     };
# Versão customizada do Brave
  brave-custom = pkgs.symlinkJoin {
    name = "brave";
    paths = [ 
      (pkgs.brave.override {
        commandLineArgs = [
          "--password-store=gnome-libsecret"
          "--ignore-gpu-blocklist"
          "--enable-gpu-rasterization"
          "--enable-zero-copy"
          "--enable-features=VaapiVideoDecoder"
          "--disable-features=UseChromeOSDirectVideoDecoder"
        ];
      }) 
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/brave \
        --set VDPAU_DRIVER "va_gl" \
        --set LIB_DRIVER_NAME "iHD" \
        --set __EGL_VENDOR_LIBRARY_FILENAMES "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json" \
        --set __GLX_VENDOR_LIBRARY_NAME "mesa"
    '';
  };

in {
  home = {
    packages = with pkgs; [ 
      dconf
      xarchiver
      # android-wayland                         # Office packages
      android-studio
      # flutter
      # gradle
      # winePackages.unstable
      wineWowPackages.stable
      # wine64
      wezterm
      wofi
      firefox
      # (brave.override {
      #   commandLineArgs = "--password-store=gnome-libsecret";
      # })
      brave-custom
      postman
      appimage-run
      lutris
      podman-desktop
      vlc
      microsoft-edge
      obs-studio
      rclone

    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

}
