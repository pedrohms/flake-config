{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      myFlakeVersion = "1.0.28";
      user = "pedro"; 
      # user = "framework"; 
      overlay-stable = final: prev: {
        stable = inputs.nixpkgs-stable.legacyPackages.${prev.system};
      };
      my-overlays = [
        inputs.neovim-nightly-overlay.overlay
        inputs.nixpkgs-f2k.overlays.window-managers
        overlay-stable
        (self: super: {
          waybar = super.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          });
        })
      ];
      location = "$HOME/.setup";
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user location  home-manager my-overlays myFlakeVersion;
        }
      );
      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user my-overlays myFlakeVersion;
        }
      );
    };
}
