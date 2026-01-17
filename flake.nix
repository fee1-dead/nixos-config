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
    } @inputs :
    let
      _ = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          # TODO/FIXME
          #        rocmSupport = true;
        };
      };
      nixpkgs-aarch64 = import nixpkgs {
        system = "aarch64-linux";
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      };
    in
    {
      # PC
      nixosConfigurations.uwu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./usage.nix
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
        specialArgs = { inherit inputs; };
        modules = [
          ./usage.nix
          ./per-system/thinkpad.nix
          ./per-system/thinkpad-hw.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.beef = import ./users/beef/home.nix;
          }
        ];
      };
      # Spark
      nixosConfigurations.awa = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./base.nix
          ./per-system/spark.nix
          ./per-system/spark-hw.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.beef = import ./users/beef/home.nix;
          }
        ];
      };
    };
}
