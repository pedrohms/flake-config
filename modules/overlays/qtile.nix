[
  (final: super: {
    pythonPackagesOverlays =
      (super.pythonPackagesOverlays or [])
      ++ [
        (_: pprev: {
          pywlroots = pprev.pywlroots.overridePythonAttrs (_: rec {
            version = "0.16.5";
            src = super.fetchPypi {
              inherit version;
              pname = "pywlroots";
              hash = "sha256-W43RCJektumgvO9K3K3mHR1BiyZXsHj4fN2EkGlJChQ=";
            };
            buildInputs = with super; [libinput libxkbcommon pixman xorg.libxcb xorg.xcbutilwm udev wayland wlroots_0_16];
          });
          qtile = pprev.qtile.overridePythonAttrs (old: {
            version = ''unstable-2023-09-20''; # qtile
            src = super.fetchFromGitHub {
              owner = "qtile";
              repo = "qtile";
              rev = ''45f249cddd89f782fa309a16b5ad653eab03b9c2''; # qtile
              hash = ''sha256-NZBPTvvt944j/rhoPKUQpbiQAuG9SFE2QP6yR7ISG0Q=''; # qtile
            };
            prePatch = ''
              substituteInPlace libqtile/backend/wayland/cffi/build.py \
                --replace /usr/include/pixman-1 ${super.pixman.outPath}/include \
                --replace /usr/include/libdrm ${super.libdrm.dev.outPath}/include/libdrm
            '';
            buildInputs = with super;
              [
                libinput
                wayland
                libxkbcommon
                xorg.xcbutilwm
                wlroots_0_16
              ];
            propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ (with super; [python3Packages.pulsectl python3Packages.pulsectl-asyncio]);
          });
          qtile-extras = pprev.qtile-extras.overridePythonAttrs (old: {
            version = ''unstable-2023-09-20''; # extras
            format = "pyproject";
            src = super.fetchFromGitHub {
              owner = "elParaguayo";
              repo = "qtile-extras";
              rev = ''9e666973d13159991f8ec9be39fab7ff5f58f43e''; # extras
              hash = ''sha256-Dc/58AIplJAZAA97NQ0mRi5iyG/TcqkRiiKQZXowWL4=''; # extras
            };
            checkInputs = (old.checkInputs or []) ++ [super.python3Packages.pytest-lazy-fixture];
            pytestFlagsArray = ["--disable-pytest-warnings"];
            disabledTests =
              (old.disabledTests or [])
              ++ [
                "1-x11-currentlayout_manager1-55"
                "test_githubnotifications_colours"
                "test_githubnotifications_logging"
                "test_githubnotifications_icon"
                "test_githubnotifications_reload_token"
                "test_image_size_horizontal"
                "test_image_size_vertical"
                "test_image_size_mask"
                "test_widget_init_config"
                "test_mpris2_popup"
                "test_snapcast_icon"
                "test_snapcast_icon_colour"
                "test_snapcast_http_error"
                "test_syncthing_not_syncing"
                "test_syncthing_is_syncing"
                "test_syncthing_http_error"
                "test_syncthing_no_api_key"
                "test_visualiser"
                "test_no_icons"
                "test_currentlayouticon_missing_icon"
                "test_no_filename"
                "test_no_image"
                "test_decoration_output"
                "test_global_menu"
                "test_strava"
              ];
          });
        })
      ];
    python3 = let
      self = super.python3.override {
        inherit self;
        packageOverrides = super.lib.composeManyExtensions final.pythonPackagesOverlays;
      };
    in
      self;
    python3Packages = final.python3.pkgs;
  })
]
