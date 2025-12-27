{
  description = "A declarative Neovim setup for lf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations.lf = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          # Import the nixvim module
          nixvim.homeManagerModules.nixvim
          # Your home-manager configuration
          ./home.nix
        ];
      };
    };
}
