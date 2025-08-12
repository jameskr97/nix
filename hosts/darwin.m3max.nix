# macOS configuration for m3max
{ pkgs, ... }: {

  environment.systemPackages = [
    pkgs.vim
    pkgs.vscodium
    pkgs.wezterm
    pkgs.lazygit
  ];
  
  fonts.packages = [
    pkgs.mplus-outline-fonts.githubRelease
  ];

  system.primaryUser = "james";
  system.defaults = {
    dock.show-recents = false;
  };

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowBroken = true;
  nix.enable = false;
}
