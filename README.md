# Global Development Environment Setup

A comprehensive Nix configuration for installing all development tools globally across machines. This setup ensures you have a consistent, reproducible development environment on any Linux system.

## 🎯 Goal

Install **all development tools once, globally** so they're available everywhere without needing project-specific environments. Perfect for developers who want a fully-equipped system ready for any type of development work.

## 🔧 What Gets Installed

### Programming Languages & Runtimes
- **Python 3.13** with pip, virtualenv, poetry
- **Node.js 22** with npm, yarn, pnpm
- **Go 1.24**
- **Rust** (latest stable) with cargo, rustfmt, clippy
- **Java 21** with gradle, maven
- **.NET 8 SDK**
- **Ruby 3.3** with bundler
- **PHP 8.3** with composer

### Build Tools & Compilers
- **GCC** and **Clang** (C/C++)
- **Make**, **CMake**, **Ninja**, **Meson**
- **Autoconf**, **Automake**, **pkg-config**
- **GDB**, **Valgrind** (debugging)

### Container & Cloud Tools
- **Docker** and **Docker Compose**
- **Podman**, **Buildah**, **Skopeo**
- **AWS CLI**, **Google Cloud SDK**, **Azure CLI**
- **Terraform**, **kubectl**, **Helm**

### System Utilities
- **Git** with **GitHub CLI** (gh)
- **curl**, **wget**, **jq**, **yq**
- **ripgrep** (rg), **fd**, **fzf**, **bat**, **eza**
- **htop**, **btop**, **tree**
- Archive tools: **zip**, **unzip**, **p7zip**, **tar**

### Productivity & Workflow Tools
- **zoxide** - Smart cd command with frecency
- **tmux** - Terminal multiplexer
- **pass** - Password manager
- **stow** - Symlink farm manager
- **doppler** - Secrets management

### Development Utilities
- **Vim** and **Neovim** (with enhanced configs)
- **direnv** for project environments
- Database tools: **SQLite**, **PostgreSQL**, **MySQL**, **Redis**
- Network tools: **nmap**, **netcat**, **tcpdump**
- Security: **GPG**, **OpenSSH**, **OpenSSL**

## 🚀 Quick Setup

### 1. Install Nix (if not already installed)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Clone and Install
```bash
git clone <your-repo-url>
cd nix-system
./install.sh
```

### 3. Restart Shell
```bash
# Restart your terminal or run:
source ~/.bashrc
```

That's it! All tools are now available globally.

## 📋 Manual Installation Steps

If you prefer to run the commands manually:

```bash
# 1. Enable flakes (if not already enabled)
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 2. Install Home Manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# 3. Apply configuration
home-manager switch --flake .#default
```

## 🔄 Updating

Keep your tools up to date:

```bash
# Update package versions
nix flake update

# Apply updates
home-manager switch --flake .#default

# Clean old generations (optional)
nix-collect-garbage -d
```

## 🏠 Setting Up New Machines

To replicate this setup on a new machine:

1. **Install Nix** (see Quick Setup step 1)
2. **Clone this repository**
3. **Run `./install.sh`**

Everything will be identical across machines!

## ⚙️ Customization

### Adding More Tools

Edit `flake.nix` and add packages to the `globalDevTools` list:

```nix
globalDevTools = with pkgs; [
  # ... existing packages ...
  your-new-package
];
```

Then run:
```bash
home-manager switch --flake .#default
```

### Modifying Git Configuration

Edit the git section in `flake.nix`:

```nix
programs.git = {
  enable = true;
  userName = "Your Name";        # Change this
  userEmail = "your@email.com";  # Change this
  # ... other settings
};
```

### Adding Shell Aliases

Add to the `shellAliases` section in `flake.nix`:

```nix
shellAliases = {
  # ... existing aliases ...
  your-alias = "your-command";
};
```

## 🧪 Testing Installation

Verify everything works in a clean Docker container:

```bash
./docker-test.sh
```

This will:
- Create a clean Ubuntu container
- Install Nix from scratch
- Apply your configuration
- Test all major tools
- Verify the `nix-list` command works

You can also test manually on your system:

```bash
# Check programming languages
python3 --version
node --version
go version
rustc --version
java --version

# Check build tools
gcc --version
make --version
cmake --version

# Check container tools
docker --version
podman --version

# Check utilities
git --version
rg --version
fd --version
bat --version

# List all tools
nix-list
```

## 🗂️ Project Structure

```
nix-system/
├── flake.nix          # Main configuration (global installation)
├── install.sh         # Automated installation script
├── configuration.nix  # System-level configuration (optional)
├── home.nix           # Legacy home-manager config
├── config/
│   ├── bashrc         # Enhanced bash configuration
│   └── vimrc          # Vim configuration
└── README.md          # This file
```

## 🆘 Troubleshooting

### Nix not found after installation
```bash
source /etc/profile
```

### Home Manager command not found
```bash
nix-shell '<home-manager>' -A install
```

### Tools not available after installation
```bash
# Restart your shell or:
source ~/.bashrc
```

### Permission denied for Docker
```bash
sudo usermod -aG docker $USER
# Log out and back in
```

## 🌟 Benefits

- ✅ **Consistent environments** across all machines
- ✅ **Reproducible builds** with exact package versions
- ✅ **Easy rollbacks** if something breaks
- ✅ **Declarative configuration** - everything in code
- ✅ **No conflicts** between different tool versions
- ✅ **Isolated from system packages** - won't break your OS

## 🔗 Useful Commands

```bash
# List installed packages
home-manager packages

# Check configuration
home-manager news

# Rollback to previous generation
home-manager generations
home-manager switch --flake .#default --switch-generation <number>

# Remove old generations
nix-collect-garbage -d
```

---

**Happy coding!** 🎉 Your development environment is now ready for any project.

### Clone and Enter Environment
```bash
git clone <your-repo-url> nix-system
cd nix-system
nix develop
```

## 📦 What's Included

### Programming Languages & Runtimes
- **Python 3.13** with pip, poetry, virtualenv
- **Node.js 22** with npm, yarn, pnpm
- **Go 1.24** with standard toolchain
- **Rust** (latest stable) with cargo, rustfmt, clippy
- **C/C++** with gcc, clang, llvm
- **Java 21** with gradle, maven
- **.NET 8 SDK**
- **Ruby 3.3** with bundler
- **PHP 8.3** with composer

### Build Systems & Tools
- **Make**, **CMake**, **Ninja**, **Meson**
- **Autotools** (autoconf, automake, libtool)
- **pkg-config**
- Various language-specific build tools

### Development Tools
- **Git** with GitHub CLI (gh)
- **Docker** and **Podman** for containerization
- **Text Editors**: Vim, Neovim, VS Code Cursor
- **Debugging**: GDB, LLDB, Valgrind, Strace
- **Performance**: Hyperfine, Performance tools

### System Utilities
- **File management**: fd, ripgrep, bat, eza, tree
- **Network tools**: curl, wget, nmap, netcat
- **Archive tools**: zip, unzip, tar, 7zip
- **Database tools**: SQLite, PostgreSQL, MySQL, Redis
- **Cloud tools**: AWS CLI, Google Cloud SDK, Azure CLI, Terraform, kubectl

## 🎯 Specialized Environments

### Default Development Environment
```bash
nix develop
```
Includes all tools listed above.

### Python Development
```bash
cd environments/python
nix develop
```
Python-focused environment with scientific computing, web frameworks, and ML tools:
- NumPy, Pandas, Matplotlib, Seaborn
- Django, Flask, FastAPI
- Jupyter, IPython
- TensorFlow, PyTorch, Scikit-learn
- Testing with pytest, black, mypy

### Web Development
```bash
cd environments/web
nix develop
```
Modern web development stack:
- Node.js ecosystem with latest tools
- Build tools: Vite, Webpack, Parcel
- CSS preprocessors: Sass, Less
- Testing: Jest, Cypress, Playwright
- Browsers: Chromium, Firefox

### Systems Programming
```bash
cd environments/systems
nix develop
```
Low-level development environment:
- C/C++ with modern toolchain
- Rust with complete ecosystem
- Go with standard tools
- Assembly tools (NASM)
- Performance and debugging tools

### Minimal Environment
```bash
nix develop .#minimal
```
Essential tools only for lighter resource usage.

### Mobile Development
```bash
nix develop .#mobile
```
Android development with Java, Gradle, and Android tools.

## 🏠 Home Manager Integration

Install user-level configuration:

```bash
# First time setup
nix run home-manager/master -- init

# Apply configuration
home-manager switch --flake .#default
```

This configures:
- Shell aliases and functions
- Git configuration
- Vim setup
- Direnv integration
- GPG configuration

## ⚙️ System Configuration (NixOS)

For NixOS systems, use the provided `configuration.nix`:

```bash
sudo cp configuration.nix /etc/nixos/
sudo nixos-rebuild switch
```

## 🔧 Customization

### Adding New Packages

Edit `flake.nix` and add packages to the `buildInputs` list:

```nix
buildInputs = with pkgs; [
  # existing packages...
  your-new-package
];
```

### Creating Custom Environments

1. Create a new directory in `environments/`
2. Add a `flake.nix` with your specific requirements
3. Use existing environments as templates

### Shell Configuration

- **Bash**: Copy `config/bashrc` to `~/.bashrc`
- **Vim**: Copy `config/vimrc` to `~/.vimrc`

## 📝 Usage Examples

### Development Workflow

```bash
# Clone your project
git clone <project-repo>
cd project

# Enter development environment
nix develop /path/to/nix-system

# Or use a specific environment
nix develop /path/to/nix-system#python
```

### Project-Specific Environments

Create a `flake.nix` in your project directory:

```nix
{
  inputs.nix-system.url = "path:/path/to/nix-system";
  
  outputs = { self, nix-system }:
    nix-system.lib.mkProjectShell {
      additionalPackages = with nix-system.pkgs; [
        # project-specific packages
      ];
    };
}
```

### Using direnv

Create `.envrc` in your project:

```bash
use flake /path/to/nix-system#python
```

Environment will automatically load when entering the directory.

## 🚀 Advanced Features

### Docker Integration

Build development containers:

```bash
# Create development container
docker run -it --rm -v $(pwd):/workspace nixos/nix
```

### CI/CD Integration

Use in GitHub Actions:

```yaml
- uses: cachix/install-nix-action@v22
- run: nix develop --command make build
```

### Cross-Platform Support

The flake works on:
- Linux (x86_64, aarch64)
- macOS (x86_64, aarch64)
- Windows (via WSL2)

## 🛠️ Maintenance

### Update Dependencies

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Garbage Collection

```bash
# Clean old generations
nix-collect-garbage -d

# Clean with age limit
nix-collect-garbage --delete-older-than 30d
```

### Check System Health

```bash
# Check flake
nix flake check

# Show system info
nix-info -m
```

## 🔍 Troubleshooting

### Common Issues

**Flakes not enabled:**
```bash
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

**Build failures:**
- Check if unfree packages are allowed
- Update flake inputs
- Clear build cache: `nix store gc`

**Performance issues:**
- Use binary caches
- Enable parallel builds
- Use `nix develop` instead of `nix-shell`

### Getting Help

- **Nix Manual**: https://nixos.org/manual/nix/stable/
- **NixOS Wiki**: https://nixos.wiki/
- **Home Manager**: https://nix-community.github.io/home-manager/

## 📄 Project Structure

```
nix-system/
├── flake.nix              # Main flake with all environments
├── home.nix               # Home Manager configuration
├── configuration.nix      # NixOS system configuration
├── environments/          # Specialized development environments
│   ├── python/           # Python-focused environment
│   ├── web/              # Web development environment
│   ├── systems/          # Systems programming environment
│   └── README.md         # Environment documentation
├── config/               # Configuration files
│   ├── bashrc           # Enhanced bash configuration
│   └── vimrc            # Vim development setup
└── README.md            # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes with `nix flake check`
4. Submit a pull request

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [NixOS](https://nixos.org/) for the amazing package manager
- [Home Manager](https://github.com/nix-community/home-manager) for user environment management
- The Nix community for excellent documentation and support

---

**Happy coding! 🎉**

For questions or issues, please open a GitHub issue or check the troubleshooting section above.