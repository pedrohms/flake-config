{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-staging.url = "github:nixos/nixpkgs/staging";
    nixpkgs-staging-next.url = "github:nixos/nixpkgs/staging-next";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=cba1ade848feac44b2eda677503900639581c3f4";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # dwl-source = {
    #   url = "git+https://codeberg.org/dwl/dwl?rev=2b171fd5010379a8674afa012245fea5a590e472";
    #   flake = false;
    # };
    yambar-source = {
      url = "git+https://codeberg.org/dnkl/yambar?rev=547cef5afbfbcbf9fe78705c7b5661059b706346";
      flake = false;
    };
  };

  # outputs = inputs @ { self, nixpkgs, home-manager, dwl-source, yambar-source, nixpkgs-staging-next, nixpkgs-stable, ... }:
  outputs = inputs @ { self, nixpkgs, home-manager, yambar-source, nixpkgs-staging-next, nixpkgs-stable, ... }:
    let
      myFlakeVersion = "1.0.47";
      user = "pedro"; 
      # user = "framework"; 
      #overlay-stable = final: prev: {
      #  stable = inputs.nixpkgs-stable.legacyPackages.${prev.system};
      #};
      # overlay-staging = final: prev: {
      #   staging = inputs.nixpkgs-staging.legacyPackages.${prev.system};
      # };
      pkgs-staging-next = import nixpkgs-staging-next {
        system = "x86_64-linux";
      };
      my-overlays = [
        inputs.neovim-nightly-overlay.overlays.default
        inputs.nixpkgs-f2k.overlays.window-managers
        # overlay-staging
        #overlay-stable
        (self: super: {
          waybar = super.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          });
        })
        (self: super: {
          yambar = super.yambar.overrideAttrs (oldAttrs: rec {
            src = yambar-source;
          });
          # dwl = super.dwl.overrideAttrs (oldAttrs: rec {
          #   src = dwl-source;
          #   patches = [
          #     ./dwl-patches/focusdirection.patch
          #     ./dwl-patches/attachbottom.patch
          #     ./dwl-patches/monfig.patch
          #     ./dwl-patches/restoreTiling.patch
          #     ./dwl-patches/toggleKbLayout.patch
          #     ./dwl-patches/autostart.patch
          #     ./dwl-patches/vanitygaps.patch
          #   ];
          # });
        })
      ]; # ++ import modules/overlays/qtile.nix;
      location = "$HOME/.setup";
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user location  home-manager my-overlays myFlakeVersion pkgs-staging-next yambar-source;
          # inherit inputs nixpkgs user location  home-manager my-overlays myFlakeVersion pkgs-staging-next dwl-source yambar-source;
        }
      );
      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user my-overlays myFlakeVersion yambar-source;
          # inherit inputs nixpkgs home-manager user my-overlays myFlakeVersion dwl-source yambar-source;
        }
      );
    };
}
