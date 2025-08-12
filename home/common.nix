# Common home-manager configuration across all platforms
{ config, pkgs, lib, ... }:

{
  home.username = "james";
  home.stateVersion = "25.05";
  
  # Common packages across all platforms
  home.packages = with pkgs; [];
  home.file = {};
  home.sessionVariables = {};
  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "James";
    userEmail = "james@jameskr.dev";
  };
}
