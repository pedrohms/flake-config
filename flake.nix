{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-staging.url = "github:nixos/nixpkgs/staging";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-staging";
    };
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dwl-source = {
      url = "github:djpohly/dwl/ab87410023a139c124bccb2817e567a7fa4fabab"; flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, dwl-source, ... }:
    let
      myFlakeVersion = "1.0.45";
      user = "pedro"; 
      # user = "framework"; 
      overlay-stable = final: prev: {
        stable = inputs.nixpkgs-stable.legacyPackages.${prev.system};
      };
      overlay-staging = final: prev: {
        staging = inputs.nixpkgs-staging.legacyPackages.${prev.system};
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
      ] ++ import modules/overlays/qtile.nix;
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
          inherit inputs nixpkgs home-manager user my-overlays myFlakeVersion dwl-source;
        }
      );
    };
}
