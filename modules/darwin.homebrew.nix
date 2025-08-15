{ homebrew-core, homebrew-cask, meta, ... } : {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "james";

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };
}