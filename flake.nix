{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      _ = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          # TODO/FIXME
          #        rocmSupport = true;
        };
      };
    in
    {
      # PC
      nixosConfigurations.uwu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./per-system/pc.nix
          ./per-system/pc-hw.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.beef = import ./users/beef/home.nix;
          }
        ];

      };
      # ThinkPad
      nixosConfigurations.ovo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./per-system/thinkpad.nix
          ./per-system/thinkpad-hw.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.beef = import ./users/beef/home.nix;
          }
        ];
      };
    };
}
