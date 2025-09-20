{ config, pkgs, ... }:

{
  # Home Manager configuration for reproducible user environment
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  
  # This value determines the Home Manager release that your
  # configuration is compatible with. Don't change unless you know what you're doing.
  home.stateVersion = "24.05";

  # Packages to install in user environment
  home.packages = with pkgs; [
    # Development tools
    gcc
    clang
    python313
    nodejs_22
    go_1_24
    rustc
    cargo
    
    # Build systems
    gnumake
    cmake
    ninja
    meson
    
    # Editors and tools
    vim
    neovim
    git
    curl
    wget
    jq
    ripgrep
    fd
    fzf
    bat
    eza
    tree
    htop
    
    # Container tools
    docker
    docker-compose
    
    # Archive tools
    unzip
    zip
    gnutar
    
    # Network tools
    nmap
    netcat
    
    # Security
    gnupg
    openssh
    
    # Productivity
    direnv
    nix-direnv
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";  # Change this
    userEmail = "your.email@example.com";  # Change this
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "vim";
      merge.tool = "vimdiff";
      diff.tool = "vimdiff";
    };
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      cm = "commit";
      pl = "pull";
      ps = "push";
      lg = "log --oneline --graph --decorate";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
    };
  };

  # Shell configuration
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -la";
      la = "eza -la";
      ls = "eza";
      cat = "bat";
      find = "fd";
      grep = "rg";
      ".." = "cd ..";
      "..." = "cd ../..";
      "nix-shell" = "nix develop";
      "nix-update" = "nix flake update";
      "nix-clean" = "nix-collect-garbage -d";
    };
    
    bashrcExtra = ''
      # Development environment variables
      export EDITOR=vim
      export BROWSER=firefox
      export TERM=xterm-256color
      
      # Language-specific settings
      export GOPATH="$HOME/go"
      export CARGO_HOME="$HOME/.cargo"
      export RUSTUP_HOME="$HOME/.rustup"
      
      # Development aliases
      alias py='python3'
      alias dc='docker-compose'
      alias k='kubectl'
      alias tf='terraform'
      
      # Nix aliases
      alias nix-search='nix search nixpkgs'
      alias nix-shell='nix develop'
      
      # Custom functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }
      
      # Improved history
      export HISTSIZE=10000
      export HISTFILESIZE=10000
      export HISTCONTROL=ignoredups:erasedups
      shopt -s histappend
      
      # Better tab completion
      bind "set completion-ignore-case on"
      bind "set show-all-if-ambiguous on"
      
      # Color support
      export CLICOLOR=1
      export LSCOLORS=GxFxCxDxBxegedabagaced
      
      # Load direnv if available
      if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook bash)"
      fi
      
      # Nix-specific settings
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      fi
      
      echo "🏠 Home Manager environment loaded!"
    '';
  };

  # Vim configuration
  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      hlsearch = true;
    };
    extraConfig = ''
      syntax on
      set background=dark
      set wildmenu
      set wildmode=list:longest
      set backspace=indent,eol,start
      set ruler
      set showcmd
      set incsearch
      set hlsearch
      
      " Clear search highlighting
      nnoremap <C-l> :nohlsearch<CR><C-l>
      
      " Better navigation
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
    '';
  };

  # Direnv configuration
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # GPG configuration
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # XDG directories
  xdg.enable = true;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}