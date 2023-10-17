{ inputs, user, pkgs, my-overlays, ... }:

{

  home = {
    packages = with pkgs; [ 
      azuredatastudio
      android-studio
      gradle
      jdk11
      wezterm
      wofi
      postman
    ];

  };

  services.kanshi = {
    enable = true;

    profiles = {
      office = {
        outputs = [
          {
            criteria = "HDMI-A-0";
            position = "0,0";
            mode = "1920x1080@60Hz";
          }
          {
            criteria = "DVI-D-0";
            position = "1920,0";
            mode = "1920x1080@60Hz";
          }
        ];
      };
    };
  };

  wayland = {
    windowManager = {
      sway = {
        config = {
          terminal = "wezterm";
          startup = [ 
            { command = "waybar"; }
            { command = "wezterm start tmux"; }
          ];
        };
      };
    };
  };
}
