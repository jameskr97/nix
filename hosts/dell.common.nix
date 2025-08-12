# Common configuration for all Dell servers
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # Hardware configuration
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # === HARDWARE CONFIGURATION ===
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # === SYSTEM CONFIGURATION ===
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Timezone
  time.timeZone = "America/New_York";

  # === SSH CONFIGURATION ===
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      UsePAM = true;
      PubkeyAuthentication = true;
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      PermitEmptyPasswords = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # === USER CONFIGURATION ===
  # Root SSH keys
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILn0IyJv3BuwOFrEU3XXJNQ6Xq+XMcCn34ajq0u/JKgN clan-root"
  ];

  # Base packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    file
    htop
    curl
  ];

  system.stateVersion = "25.05";
}
