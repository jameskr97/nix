{
  description = "jameskr nixos configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, colmena, nix-darwin, home-manager, ... }:
    let
      # Import metadata - single source of truth
      meta = import ./metadata.nix;
      
      # Shared home configuration
      homeConfig = import ./home/desktop.nix;

      # Function to create colmena server configuration
      mkServer = name: serverConfig: {
        imports = serverConfig.modules ++ [
          home-manager.nixosModules.home-manager
        ];
        
        # Set hostname from metadata
        networking.hostName = serverConfig.hostname;
        
        # Deployment configuration
        deployment.targetHost = serverConfig.ip;
        deployment.targetUser = "root";
        deployment.buildOnTarget = true;
        
        # Include home-manager for servers
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.james = homeConfig;
        };
      };

      # Darwin configuration
      darwinConfig = {
        imports = [
          ./hosts/darwin.m3max.nix
          home-manager.darwinModules.home-manager
        ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.james = homeConfig;
        };
      };
    in
  {
    # Colmena deployment - loop through metadata servers
    colmena = {
      meta.nixpkgs = import nixpkgs { system = "x86_64-linux"; };
    } // builtins.mapAttrs mkServer meta.servers;

    # Darwin system
    darwinConfigurations."m3max" = nix-darwin.lib.darwinSystem {
      modules = [ darwinConfig ];
    };

    # Standalone home-manager (fallback)
    homeConfigurations."james" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      modules = [ homeConfig ];
    };
  };
}
