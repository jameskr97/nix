# macOS configuration for m3max
let 
  meta = import ../metadata.nix;
in
{ pkgs, ... }: {

  environment.systemPackages = with pkgs; meta.packages.common;
  fonts.packages = with pkgs; meta.fonts;


  system.primaryUser = "james";
  system.defaults = {
    dock.show-recents = false;
  };

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowBroken = true;
  nix.enable = false;
}
