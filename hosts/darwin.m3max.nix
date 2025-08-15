# macOS configuration for m3max
{ pkgs, meta, mkPackageList, ... }: {
  environment.systemPackages = meta.packages.common;
  fonts.packages = meta.fonts;

  system.primaryUser = "james";
  system.defaults = {
    dock.show-recents = false;
  };

  # homebrew
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    caskArgs.appdir = "/Applications/Homebrew Apps";
    brews = ["nodejs"];
    casks = meta.packages.gui.casks;
  };

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  nix.enable = false;
}
