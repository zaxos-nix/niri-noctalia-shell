{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: {
    # import any other modules from here
    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.niri
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader configuration
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Enabled and configured themed GRUB for EFI
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    theme = pkgs.catppuccin-grub.override { flavor = "mocha"; };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Africa/Nairobi";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # GNOME options
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Fixed: Enable explicit mounting daemon support
  services.udisks2.enable = true;
  security.polkit.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users."izo" = {
    isNormalUser = true;
    description = "izo";
    # Fixed: Added storage and disk groups so file managers can mount drives
    extraGroups = [ "networkmanager" "wheel" "storage" "disk" ];
    packages = with pkgs; [ ];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    brave
    zed-editor
    foot
    kitty
    fish
    htop
    mpv
    img
    pcmanfm
    nemo
    zathura
    ntfs3g
    lxqt.lxqt-policykit # Fixed: Gives Niri/standalone layouts an auth agent popup if needed
  ];

  system.stateVersion = "26.05";

};
}
