{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    typst-lsp.url = "github:nvarner/typst-lsp";
  };
  outputs = { self, nixpkgs, home-manager, ... } @inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.users.beef = import ./users/beef/home.nix;
        }
      ];
      
    };
  };
}
