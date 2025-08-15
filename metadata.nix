{ pkgs, ...}: {
  # Users configuration
  users = {
    james = {
      username = "james";
      email = "james@jameskr.dev";
      sshKeys = [];
    };
    
    root = {
      username = "root";
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILn0IyJv3BuwOFrEU3XXJNQ6Xq+XMcCn34ajq0u/JKgN clan-root"
      ];
    };
  };

  # Server inventory with their specific modules
  dell_modules = [
    "./hosts/dell.common.nix"
    "./modules/file-server.nix"
  ];
  servers = {
    dell01 = { hostname = "dell01"; ip = "10.20.0.21"; };
    dell02 = { hostname = "dell02"; ip = "10.20.0.22"; };
    dell03 = { hostname = "dell03"; ip = "10.20.0.23"; };
    dell04 = { hostname = "dell04"; ip = "10.20.0.24"; };
  };

  # Package categories
  packages = {
    # Common CLI tools across all systems
    common = [
      pkgs.vim

      # Development
      pkgs.git
      pkgs.lazygit
      pkgs.lazydocker

      pkgs.nodejs
      pkgs.chezmoi
    ];

    # Desktop GUI applications
    gui = {
      casks = [
        # Essentials
        "ghostty"
        "transmit"
        "jetbrains-toolbox"

        # Research
        "anki"
        "rstudio"
        "transmit"

        # Social
        "discord"
        "element"
        "zotero"

        # Rogue Aeomeba
        "soundsource"
        "audio-hijack"
        "loopback"
        "piezo"

        # Misc
        "claude"
        "utm"
        "orbstack"
        "steam"
      ];
    };
  };

  # Fonts
  fonts = [
    pkgs.mplus-outline-fonts.githubRelease
    pkgs.jetbrains-mono
  ];
}
