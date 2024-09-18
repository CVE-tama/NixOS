# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, pkgs, ...}: {

 imports =
   [
     ./hardware-configuration.nix
   ];

 nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = ["nvidia"];

  services.xserver.screenSection = ''
    Option  "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option  "AllowIndirectGLXProtocol" "off"
    Option  "TripleBuffer" "on"
  '';

  hardware.opengl.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  boot.kernelParams = ["nvidia-drm.modeset=1"];

services.xserver.config = ''
  Section "Device"
    Identifier "nvidia0"
    Driver "nvidia"
    BusID "PCI:25:0:0"
    Option "AllowEmptyInitialConfiguration"
  EndSection
'';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
};
  users.users.tama = {
    isNormalUser = true;
    description = "tama";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kate
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
  nix
  pciutils
  discord
  git
  vim
  zoom-us
  neovim
  htop
  libgcc
  ripgrep
  python3
  nerdfonts
  tmux
  phoronix-test-suite
  lm_sensors
  memtester
  ];


  system.stateVersion = "24.05"; # Did you read the comment?
}
