{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    suckless-git-overlay.url = "github:06kellyjac/suckless-git-overlay";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      user = "pedro"; 
      # user = "framework"; 
      my-overlays = [
          inputs.neovim-nightly-overlay.overlay
          inputs.nixpkgs-f2k.overlays.window-managers
          inputs.suckless-git-overlay.overlay
          (self: super: {
            waybar = super.waybar.overrideAttrs (oldAttrs: {
              mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            });
            dwm = super.dwm.overrideAttrs (oldAttrs: rec {
              patches = [
                # (super.fetchpatch {
                #   url = "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff";
                #   sha256 = "mrHh4o9KBZDp2ReSeKodWkCz5ahCLuE6Al3NR2r2OJg=";
                # })
                # (super.fetchpatch {
                #   url = "https://dwm.suckless.org/patches/pertag/dwm-pertag-20200914-61bb8b2.diff";
                #   sha256 = "wRZP/27V7xYOBnFAGxqeJFXdoDk4K1EQMA3bEoAXr/0=";
                # })
                # (super.fetchpatch {
                #   url = "https://dwm.suckless.org/patches/fancybar/dwm-fancybar-20220527-d3f93c7.diff";
                #   sha256 = "twTkfKjOMGZCQdxHK0vXEcgnEU3CWg/7lrA3EftEAXc=";
                # })
                # (super.fetchpatch {
                #   url = "https://dwm.suckless.org/patches/alpha/dwm-alpha-20201019-61bb8b2.diff";
                #   sha256 = "IkVGUl0y/DvuY6vquSmqv2d//QSLMJgFUqi5YEiM8cE=";
                # })
                (super.fetchpatch {
                  url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.4.diff";
                  sha256 = "TXErH76w403T9tSJYu3tAJrQX3Y3lKSulKH0UdQLG/g=";
                })
                (super.fetchpatch {
                  url = "https://dwm.suckless.org/patches/cool_autostart/dwm-cool-autostart-6.2.diff";
                  sha256 = "/LYv65Z4mLjkirhiz8X47/bBI6KLZywqDSkJNyZK5UI=";
                })
              ];
              configFile = super.writeText "config.h" (builtins.readFile ./modules/desktop/dwm/dwm-config.h);
              postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
            });
          })
        ];
      location = "$HOME/.setup";
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user location  home-manager my-overlays;
        }
      );
      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user my-overlays;
        }
      );
    };
}
