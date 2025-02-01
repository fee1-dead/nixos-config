{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, lix-module, ... } @inputs:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        # TODO/FIXME
#        rocmSupport = true;
      };
    };
  in {
    # HP Laptop
    nixosConfigurations.owo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./common.nix
        ./per-system/laptop.nix
        ./per-system/laptop-hw.nix
        home-manager.nixosModules.home-manager {
          home-manager.users.beef = import ./users/beef/home.nix;
        }
        lix-module.nixosModules.default
      ];
      
    };
    # PC
    nixosConfigurations.uwu = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./common.nix
        ./per-system/pc.nix
        ./per-system/pc-hw.nix
        home-manager.nixosModules.home-manager {
          home-manager.users.beef = import ./users/beef/home.nix;
        }
        lix-module.nixosModules.default
      ];
      
    };
  };
}
