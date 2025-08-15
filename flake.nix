{
  description = "jameskr nixos configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # server deployment
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";

    # mac homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    mac-app-util.url = "github:hraban/mac-app-util";
    mac-app-util.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    nixpkgs, 
    colmena,
    nix-darwin,
    home-manager,
    mac-app-util,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ... }:
    let
      pkgs = import nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
      meta = import ./metadata.nix { inherit pkgs; };
      mkServer = name: serverConfig: {
        imports = serverConfig.modules ++ [home-manager.nixosModules.home-manager];
        
        # Set hostname from metadata
        networking.hostName = serverConfig.hostname;
        
        # Deployment configuration
        deployment.targetHost = serverConfig.ip;
        deployment.targetUser = "root";
        deployment.buildOnTarget = true;
      };

      darwinConfig = {
        imports = [
          ./hosts/darwin.m3max.nix
          ./modules/darwin.homebrew.nix
          nix-homebrew.darwinModules.nix-homebrew
        ];
        
        users.users.james.name = "james";
        users.users.james.home = "/Users/james";
      };
    in
  {
    # Colmena deployment - loop through metadata servers
    colmena = {
      meta.nixpkgs = import nixpkgs { system = "x86_64-linux"; };
    } // builtins.mapAttrs mkServer meta.servers;

    # Darwin system
    darwinConfigurations."m3max" = nix-darwin.lib.darwinSystem {
      modules = [ 
        mac-app-util.darwinModules.default
        darwinConfig
      ];
      specialArgs = { inherit meta homebrew-core homebrew-cask; };
    };

    # Standalone home-manager (fallback)
    # homeConfigurations."james" = home-manager.lib.homeManagerConfiguration {
    #   pkgs = nixpkgs.legacyPackages."aarch64-darwin";
    #   modules = [ homeConfig ];
    # };
  };
}
