#!/usr/bin/env bash

# Global Development Tools Installation Script
# This script installs all development tools globally using Nix and Home Manager

set -euo pipefail

echo "🚀 Installing Global Development Environment..."
echo "==============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    print_error "Nix is not installed. Please install Nix first:"
    echo "curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi

# Check if flakes are enabled
if ! nix --help | grep -q "flake"; then
    print_warning "Nix flakes are not enabled. Enabling experimental features..."
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_status "Working directory: $SCRIPT_DIR"

# Ensure we're in the right directory
cd "$SCRIPT_DIR"

# Install Home Manager if not already installed
if ! command -v home-manager &> /dev/null; then
    print_status "Installing Home Manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
fi

# Build and switch to the new configuration
print_status "Building and installing global development tools..."
home-manager switch --flake .#default

print_success "Global development environment installed!"
echo ""
echo "🔧 Installed tools include:"
echo "  • Programming languages: Python, Node.js, Go, Rust, Java, .NET, Ruby, PHP"
echo "  • Build tools: gcc, clang, make, cmake, ninja, meson"
echo "  • Containers: Docker, Podman"
echo "  • Cloud tools: AWS CLI, Google Cloud SDK, Azure CLI, Terraform, kubectl"
echo "  • Utilities: git, curl, jq, ripgrep, fd, bat, eza, htop, and many more"
echo ""
echo "🏠 To apply this configuration on a new machine:"
echo "  1. Install Nix: curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
echo "  2. Clone this repository"
echo "  3. Run: ./install.sh"
echo ""
echo "🔄 To update tools later:"
echo "  • nix flake update (update package versions)"
echo "  • home-manager switch --flake .#default (apply updates)"
echo ""
print_success "Setup complete! Restart your shell or source ~/.bashrc to use the new tools."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

check_nix() {
    if command -v nix >/dev/null 2>&1; then
        print_success "Nix is installed"
        nix --version
    else
        print_error "Nix is not installed"
        echo "Please install Nix first: https://nixos.org/download.html"
        echo "Run: curl -L https://nixos.org/nix/install | sh"
        exit 1
    fi
}

check_flakes() {
    if nix flake --help >/dev/null 2>&1; then
        print_success "Nix flakes are available"
    else
        print_warning "Enabling Nix flakes..."
        mkdir -p ~/.config/nix
        echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
        print_success "Nix flakes enabled"
    fi
}

install_development_environment() {
    print_header "Installing Development Environment"
    
    echo "Choose installation type:"
    echo "1) Full environment (recommended)"
    echo "2) Minimal environment" 
    echo "3) Python development"
    echo "4) Web development"
    echo "5) Systems programming"
    
    read -p "Enter choice (1-5): " choice
    
    case $choice in
        1)
            echo "Installing full development environment..."
            nix develop
            ;;
        2)
            echo "Installing minimal environment..."
            nix develop .#minimal
            ;;
        3)
            echo "Installing Python development environment..."
            nix develop ./environments/python
            ;;
        4)
            echo "Installing web development environment..."
            nix develop ./environments/web
            ;;
        5)
            echo "Installing systems programming environment..."
            nix develop ./environments/systems
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
}

setup_home_manager() {
    print_header "Setting up Home Manager"
    
    read -p "Do you want to install Home Manager configuration? (y/N): " install_hm
    
    if [[ $install_hm =~ ^[Yy]$ ]]; then
        if command -v home-manager >/dev/null 2>&1; then
            print_success "Home Manager is already installed"
        else
            print_warning "Installing Home Manager..."
            nix run home-manager/master -- init
        fi
        
        # Update Git configuration
        read -p "Enter your Git username: " git_name
        read -p "Enter your Git email: " git_email
        
        sed -i.bak "s/Your Name/$git_name/g" home.nix
        sed -i.bak "s/your.email@example.com/$git_email/g" home.nix
        
        print_warning "Applying Home Manager configuration..."
        home-manager switch --flake .#default
        print_success "Home Manager configuration applied"
    fi
}

setup_shell_config() {
    print_header "Setting up Shell Configuration"
    
    read -p "Do you want to copy shell configuration files? (y/N): " copy_config
    
    if [[ $copy_config =~ ^[Yy]$ ]]; then
        # Backup existing files
        if [ -f ~/.bashrc ]; then
            cp ~/.bashrc ~/.bashrc.backup
            print_warning "Backed up existing .bashrc to .bashrc.backup"
        fi
        
        if [ -f ~/.vimrc ]; then
            cp ~/.vimrc ~/.vimrc.backup
            print_warning "Backed up existing .vimrc to .vimrc.backup"
        fi
        
        # Copy new configurations
        cp config/bashrc ~/.bashrc
        cp config/vimrc ~/.vimrc
        
        print_success "Shell configuration files copied"
        print_warning "Please restart your shell or run: source ~/.bashrc"
    fi
}

create_direnv_config() {
    print_header "Setting up direnv (optional)"
    
    read -p "Do you want to create a .envrc file for automatic environment loading? (y/N): " create_envrc
    
    if [[ $create_envrc =~ ^[Yy]$ ]]; then
        echo "use flake" > .envrc
        
        if command -v direnv >/dev/null 2>&1; then
            direnv allow
            print_success "direnv configured - environment will load automatically"
        else
            print_warning "direnv not found in PATH. Install it to enable automatic environment loading."
        fi
    fi
}

print_final_instructions() {
    print_header "Installation Complete!"
    
    echo -e "${GREEN}Your development environment is ready!${NC}"
    echo ""
    echo "Quick start commands:"
    echo "  nix develop                    # Enter full development environment"
    echo "  nix develop .#minimal         # Enter minimal environment"
    echo "  nix develop ./environments/python  # Enter Python environment"
    echo ""
    echo "Available tools:"
    echo "  Languages: Python, Node.js, Go, Rust, C/C++, Java"
    echo "  Build tools: make, cmake, ninja, meson"
    echo "  Containers: Docker, Podman"
    echo "  Editors: vim, neovim"
    echo ""
    echo "For more information, see README.md"
}

main() {
    print_header "Development Environment Installer"
    
    check_nix
    check_flakes
    install_development_environment
    setup_home_manager
    setup_shell_config
    create_direnv_config
    print_final_instructions
}

# Run main function
main "$@"