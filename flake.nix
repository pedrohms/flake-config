{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      # user = "pedro"; 
      # user = "framework"; 
      my-overlays = [
          inputs.neovim-nightly-overlay.overlay
        ];
      location = "$HOME/.setup";
    in {
      nixosConfigurations = genAttrs [ "notepedro", "desenv07"]( user: nixosSystem {
        notepedro = "pedro";
        desenv07 = "framework";
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user location  home-manager my-overlays;
        }
      });
      homeConfigurations = genAttrs [ "notepedro", "desenv07"]( user: nixosSystem {
        notepedro = "pedro";
        desenv07 = "framework";
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user my-overlays;
        }
      });
    };
}
