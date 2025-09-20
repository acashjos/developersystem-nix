{
  description = "Global development tools installation for consistent setup across machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";  # Change to your system architecture if different
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Complete list of development tools to install globally
      globalDevTools = with pkgs; [
        # Core build tools and compilers
        gcc
        clang
        llvm
        gdb
        valgrind
        
        # Build systems
        gnumake
        cmake
        ninja
        meson
        autoconf
        automake
        libtool
        pkg-config
        
        # Programming languages and runtimes
        python313
        python313Packages.pip
        python313Packages.setuptools
        python313Packages.wheel
        python313Packages.virtualenv
        python313Packages.poetry
        python313Packages.pipx
        
        nodejs_22
        npm-check-updates
        yarn
        pnpm
        
        go_1_24
        
        rustc
        cargo
        rustfmt
        clippy
        
        # Java ecosystem
        openjdk21
        gradle
        maven
        
        # .NET
        dotnet-sdk_8
        
        # Ruby
        ruby_3_3
        bundler
        
        # PHP
        php83
        php83Packages.composer
        
        # Docker and containerization
        docker
        docker-compose
        podman
        buildah
        skopeo
        
        # Version control
        git
        gh
        gitui
        delta
        
        # Text editors and IDEs
        vim
        neovim
        emacs
        
        # System utilities
        curl
        wget
        jq
        yq
        ripgrep
        fd
        fzf
        bat
        eza
        tree
        htop
        btop
        
        # Network tools
        nmap
        netcat
        socat
        tcpdump
        
        # Archive and compression
        unzip
        zip
        p7zip
        gnutar
        gzip
        
        # Database tools
        sqlite
        postgresql
        mysql80
        redis
        
        # Cloud tools
        awscli2
        google-cloud-sdk
        azure-cli
        terraform
        kubectl
        helm
        
        # Security tools
        gnupg
        openssh
        openssl
        
        # Performance tools
        hyperfine
        bandwhich
        bottom
        
        # Documentation
        pandoc
        
        # Android development
        android-tools
        
        # Additional useful packages
        direnv
        nix-direnv
        cachix
        
        # More development utilities
        strace
        ltrace
        lsof
        tcpdump
        imagemagick
        ffmpeg
        
        # Productivity and workflow tools
        zoxide          # Smart cd command
        tmux           # Terminal multiplexer
        doppler        # Secrets management
        pass           # Password manager
        stow           # Symlink farm manager
        
        # Note: rg (ripgrep), fd, gh, jq, fzf are already included above
      ];

    in {
      # Home Manager configuration for global installation
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.username = builtins.getEnv "USER";
            home.homeDirectory = builtins.getEnv "HOME";
            home.stateVersion = "24.05";
            
            # Install all development tools globally
            home.packages = globalDevTools;
            
            # Enhanced shell configuration
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
                
                # Development aliases
                py = "python3";
                dc = "docker-compose";
                k = "kubectl";
                tf = "terraform";
                
                # Git aliases
                g = "git";
                ga = "git add";
                gc = "git commit";
                gp = "git push";
                gl = "git pull";
                gst = "git status";
                
                # Rust aliases
                cb = "cargo build";
                cr = "cargo run";
                ct = "cargo test";
                
                # Go aliases
                gob = "go build";
                gor = "go run";
                got = "go test";
                
                # Node.js aliases
                nr = "npm run";
                ni = "npm install";
                yr = "yarn run";
                yi = "yarn install";
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
                
                # Add local bins to PATH
                export PATH="$HOME/.local/bin:$HOME/bin:$GOPATH/bin:$CARGO_HOME/bin:$PATH"
                
                # Initialize zoxide (smart cd)
                if command -v zoxide >/dev/null 2>&1; then
                  eval "$(zoxide init bash)"
                  # Create z alias for zoxide
                  alias z='zoxide'
                  alias zi='zoxide query -i'
                fi
                
                # Load direnv
                if command -v direnv >/dev/null 2>&1; then
                  eval "$(direnv hook bash)"
                fi
                
                # Tmux configuration
                alias t='tmux'
                alias ta='tmux attach'
                alias tn='tmux new-session'
                alias tl='tmux list-sessions'
                
                # Nix environment info
                alias nix-list='echo "� Global Development Environment Components:
                
📋 PROGRAMMING LANGUAGES & RUNTIMES:
  • python3 (3.13)     - Python interpreter with pip, poetry, virtualenv
  • node (22)           - Node.js runtime with npm, yarn, pnpm
  • go (1.24)           - Go programming language
  • rustc/cargo         - Rust compiler and package manager
  • java (21)           - OpenJDK with gradle, maven
  • dotnet (8)          - .NET SDK
  • ruby (3.3)          - Ruby with bundler
  • php (8.3)           - PHP with composer

🔨 BUILD TOOLS & COMPILERS:
  • gcc/clang           - C/C++ compilers with LLVM
  • make/cmake/ninja     - Build systems
  • meson/autotools     - More build systems
  • gdb/valgrind        - Debugging tools
  • pkg-config          - Library configuration

🐳 CONTAINERS & CLOUD:
  • docker/podman       - Container runtimes
  • aws/gcloud/az       - Cloud CLIs (AWS, Google, Azure)
  • terraform/kubectl   - Infrastructure as code
  • helm                - Kubernetes package manager

🛠️ DEVELOPMENT UTILITIES:
  • git/gh              - Version control with GitHub CLI
  • vim/neovim          - Text editors
  • curl/wget           - HTTP clients
  • jq/yq               - JSON/YAML processors
  • direnv              - Environment management

📁 FILE & SYSTEM TOOLS:
  • rg (ripgrep)        - Fast text search
  • fd                  - Fast file finder
  • bat                 - Cat with syntax highlighting
  • eza                 - Modern ls replacement
  • fzf                 - Fuzzy finder
  • tree                - Directory tree viewer
  • htop/btop           - Process viewers

🚀 PRODUCTIVITY TOOLS:
  • zoxide (z)          - Smart cd with frecency
  • tmux (t)            - Terminal multiplexer
  • pass                - Password manager
  • stow                - Symlink farm manager
  • doppler             - Secrets management

🗄️ DATABASES:
  • sqlite/postgresql   - SQL databases
  • mysql/redis         - More database options

🔐 SECURITY & NETWORK:
  • gnupg/openssh       - Encryption and SSH
  • nmap/netcat         - Network tools
  • tcpdump             - Packet analyzer

📦 ARCHIVE & COMPRESSION:
  • zip/unzip/p7zip     - Archive tools
  • tar/gzip            - Compression utilities

💡 Usage: Type command name to use, or '\''command --help'\'' for options
🔄 Update: nix flake update && home-manager switch --flake .#default"'
                
                echo "�🚀 Global development environment ready!"
                echo "New tools: zoxide (z), tmux (t), pass, stow, doppler"
                echo "All tools installed and available globally."
                echo "💡 Run 'nix-list' to see all available tools!"
              '';
            };
            
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
              };
            };
            
            # Direnv for project-specific environments
            programs.direnv = {
              enable = true;
              enableBashIntegration = true;
              nix-direnv.enable = true;
            };
            
            # Let Home Manager install and manage itself
            programs.home-manager.enable = true;
          }
        ];
      };

      # Package for installing all tools at once
      packages.${system}.default = pkgs.buildEnv {
        name = "global-dev-tools";
        paths = globalDevTools;
      };
    };
}