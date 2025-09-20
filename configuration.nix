# NixOS System Configuration
# This file defines system-level packages and services

{ config, pkgs, ... }:

{
  # System packages available to all users
  environment.systemPackages = with pkgs; [
    # Essential system tools
    wget
    curl
    git
    vim
    htop
    tree
    unzip
    p7zip
    
    # Network tools
    nmap
    netcat
    tcpdump
    wireshark
    
    # Development essentials
    gcc
    gnumake
    cmake
    python3
    nodejs
    
    # Container tools
    docker
    docker-compose
    
    # Monitoring
    neofetch
    btop
    iotop
    
    # File management
    fd
    ripgrep
    bat
    eza
    fzf
    
    # Multimedia
    ffmpeg
    imagemagick
    
    # Archive tools
    gnutar
    gzip
    bzip2
    xz
    
    # Text processing
    jq
    yq-go
    pandoc
    
    # Security
    gnupg
    openssh
    openssl
    
    # Version control
    git
    gh
    
    # Performance tools
    perf-tools
    strace
    lsof
    
    # System utilities
    psmisc
    procps
    util-linux
    coreutils
    findutils
    which
    file
    less
    man
  ];

  # Enable nix flakes and new command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimize nix store
  nix.settings.auto-optimise-store = true;

  # Allow unfree packages (useful for some development tools)
  nixpkgs.config.allowUnfree = true;

  # Enable Docker
  virtualisation.docker.enable = true;
  
  # Add user to docker group (replace 'username' with actual username)
  # users.users.username.extraGroups = [ "docker" ];

  # SSH daemon configuration
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 3000 8000 8080 ]; # SSH and common dev ports
  };

  # Enable fish shell (optional, can be removed if you prefer bash)
  programs.fish.enable = true;
  
  # Enable zsh shell (optional)
  programs.zsh.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Enable direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Time zone and locale
  time.timeZone = "UTC";  # Change to your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  # Console configuration
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this after initial installation.
  system.stateVersion = "24.05";
}