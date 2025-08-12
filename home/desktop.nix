# Desktop-specific home-manager configuration
{ config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ];
  home.packages = with pkgs; [];
}
