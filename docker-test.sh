#!/usr/bin/env bash

# Docker Test Script for Global Development Environment
# This script tests the Nix installation in a clean Ubuntu container

set -euo pipefail

echo "🐳 Testing Global Development Environment in Docker..."
echo "====================================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed or not running"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Get the current directory (where the nix-system files are)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_status "Working directory: $SCRIPT_DIR"

# Create a temporary Dockerfile for testing
print_status "Creating test container..."

cat > "${SCRIPT_DIR}/Dockerfile.test" << 'EOF'
FROM ubuntu:22.04

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    xz-utils \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a test user
RUN useradd -m -s /bin/bash testuser && \
    echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Copy the nix-system configuration
COPY --chown=testuser:testuser . ./nix-system/

# Set up environment
ENV USER=testuser
ENV HOME=/home/testuser

WORKDIR /home/testuser/nix-system
EOF

# Build the test container
print_status "Building test container..."
docker build -f "${SCRIPT_DIR}/Dockerfile.test" -t nix-system-test "${SCRIPT_DIR}"

if [ $? -ne 0 ]; then
    print_error "Failed to build test container"
    exit 1
fi

print_success "Test container built successfully"

# Create a test script that will run inside the container
cat > "${SCRIPT_DIR}/container-test.sh" << 'EOF'
#!/bin/bash

set -euo pipefail

echo "🧪 Running tests inside container..."
echo "=================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Install Nix
print_status "Installing Nix..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

# Source Nix environment
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Enable flakes
print_status "Enabling Nix flakes..."
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Test that Nix is working
print_status "Testing Nix installation..."
if command -v nix &> /dev/null; then
    print_success "Nix installed successfully: $(nix --version)"
else
    print_error "Nix installation failed"
    exit 1
fi

# Install Home Manager
print_status "Installing Home Manager..."
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Test flake configuration
print_status "Testing flake configuration..."
nix flake check

if [ $? -eq 0 ]; then
    print_success "Flake configuration is valid"
else
    print_error "Flake configuration has errors"
    exit 1
fi

# Apply the configuration
print_status "Applying Home Manager configuration..."
home-manager switch --flake .#default

if [ $? -eq 0 ]; then
    print_success "Home Manager configuration applied successfully"
else
    print_error "Failed to apply Home Manager configuration"
    exit 1
fi

# Source the new bash configuration
source ~/.bashrc

# Test some key tools
print_status "Testing installed tools..."

test_tool() {
    local tool="$1"
    local name="$2"
    
    if command -v "$tool" &> /dev/null; then
        print_success "$name: Available"
        return 0
    else
        print_error "$name: Not found"
        return 1
    fi
}

# Test critical tools
FAILED=0
test_tool "python3" "Python" || FAILED=1
test_tool "node" "Node.js" || FAILED=1
test_tool "go" "Go" || FAILED=1
test_tool "rustc" "Rust" || FAILED=1
test_tool "gcc" "GCC" || FAILED=1
test_tool "git" "Git" || FAILED=1
test_tool "docker" "Docker" || FAILED=1
test_tool "jq" "jq" || FAILED=1
test_tool "rg" "ripgrep" || FAILED=1
test_tool "fd" "fd" || FAILED=1
test_tool "zoxide" "zoxide" || FAILED=1
test_tool "tmux" "tmux" || FAILED=1

# Test nix-list alias
print_status "Testing nix-list alias..."
if alias nix-list &> /dev/null; then
    print_success "nix-list alias available"
    echo "Sample output:"
    nix-list | head -10
else
    print_error "nix-list alias not found"
    FAILED=1
fi

# Final result
echo ""
echo "=================================="
if [ $FAILED -eq 0 ]; then
    print_success "🎉 All tests passed! Global development environment works correctly."
else
    print_error "❌ Some tests failed. Please check the configuration."
    exit 1
fi

echo ""
echo "📊 Installation Summary:"
echo "  • Nix: $(nix --version)"
echo "  • Python: $(python3 --version 2>/dev/null || echo 'Not available')"
echo "  • Node.js: $(node --version 2>/dev/null || echo 'Not available')"
echo "  • Go: $(go version 2>/dev/null | cut -d' ' -f3 || echo 'Not available')"
echo "  • Rust: $(rustc --version 2>/dev/null | cut -d' ' -f2 || echo 'Not available')"
echo ""
print_success "Container test completed successfully!"
EOF

chmod +x "${SCRIPT_DIR}/container-test.sh"

# Run the test container
print_status "Running tests in container..."
print_warning "This may take several minutes as it downloads and installs Nix and all packages..."

docker run --rm -it \
    --privileged \
    -v "${SCRIPT_DIR}/container-test.sh:/home/testuser/nix-system/container-test.sh" \
    nix-system-test \
    ./container-test.sh

TEST_RESULT=$?

# Cleanup
print_status "Cleaning up..."
rm -f "${SCRIPT_DIR}/Dockerfile.test"
rm -f "${SCRIPT_DIR}/container-test.sh"
docker rmi nix-system-test &>/dev/null || true

if [ $TEST_RESULT -eq 0 ]; then
    print_success "🎉 Docker container test completed successfully!"
    print_success "Your global development environment configuration is working correctly!"
else
    print_error "❌ Docker container test failed"
    print_error "Please check the configuration and try again"
    exit 1
fi

echo ""
echo "✅ Your nix-system configuration is ready for deployment!"
echo "💡 You can now use ./install.sh on any machine to get the same environment."