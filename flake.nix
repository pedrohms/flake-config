{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nvim-nightly, ... }:
    let
      user = "pedro";
      location = "$HOME/.setup";
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user location home-manager nvim-nightly;
        }
      );
      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user nvim-nightly;
        }
      );
    };
}
