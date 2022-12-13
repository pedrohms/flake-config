{ lib, inputs, nixpkgs, home-manager, user, location, my-overlays, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system ;
    config.allowUnfree = true;                              # Allow proprietary software
    overlays = my-overlays;
  };

  lib = nixpkgs.lib;
in
{
  notepedro = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = { inherit inputs user location; }; # Pass flake variable
    modules = [                                             # Modules that are used.
      ./notepedro
      ./configuration.nix
      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user pkgs; };  # Pass flake variable
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./notepedro/home.nix)];
        };
      }
    ];
  };

  desenv07 = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = { inherit inputs user location ; };
    modules = [
      ./desenv07
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user pkgs; };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./desenv07/home.nix)];
        };
      }
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = { inherit inputs user location; };
    modules = [
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user pkgs; }; 
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
        };
      }
    ];
  };
}
