{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix-darwin, home-manager }:
    let
    in
      (flake-utils.lib.eachDefaultSystem (system:
        let
        in
          {
            
          }
      )) // rec {
        nixosModules = {
          baseConfig = import ./base-config.nix;
        };
        darwinConfigurations = {
          olvadi = nix-darwin.lib.darwinSystem {
            system = "x86_64-darwin";
            inputs = { inherit nixpkgs; darwin = nix-darwin; };
            modules = [ nixosModules.baseConfig ];
          };
        };
      };
}
