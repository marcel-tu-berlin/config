# System Configuration & Installation

A comprehensive system setup toolkit for macOS development environments, featuring automated program installation and configuration management.

## Purpose

This repository contains scripts and configurations for quickly setting up new macOS development machines or synchronizing configurations across multiple development environments. The goal is to maintain consistency and save time when configuring new systems.

## Features

- 🚀 Automated installation of essential development tools
- 🔧 Automated configuration of dotfiles and settings
- 💾 Automatic backup of existing configurations
- 🎨 Colored terminal output for clear feedback
- 🔒 Safe installation with backup protection
- 🖥️ Optimized for macOS (with extensibility for other platforms)

## Scripts Overview

### `install-macos.sh` - macOS System Installation
Installs essential development tools and programs specifically for macOS:
- Xcode Command Line Tools
- Homebrew package manager
- Essential development tools (Ghostty terminal, tmux, git)

### `configure.sh` - Configuration Management
Manages dotfiles and system configurations (cross-platform):
- Git configuration (`.gitconfig`)
- Automatic backup of existing configurations
- Safe installation with rollback capability

## Current Configurations

- **Git Configuration** (`.gitconfig`) - Git user settings, aliases, and preferences

## Usage

### Complete System Setup (Recommended for macOS)

For a fresh macOS system, run both scripts in order:

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd config
   ```

2. Install macOS development tools:
   ```bash
   ./install-macos.sh
   ```

3. Configure dotfiles:
   ```bash
   ./configure.sh
   ```

### Individual Script Usage

#### macOS Program Installation
To install essential development tools on macOS without configuring dotfiles:
```bash
./install-macos.sh
```

#### Configuration Only
To configure dotfiles without installing programs (works on any Unix-like system):
```bash
./configure.sh
```

### What Each Script Does

#### macOS Installation Script (`install-macos.sh`)
1. **Checks system compatibility** - Ensures running on macOS
2. **Installs Xcode Command Line Tools** - Essential development utilities for macOS
3. **Installs Homebrew** - Package manager for macOS
4. **Installs development tools** - Ghostty, tmux, git via Homebrew
5. **Provides status updates** - Shows what's already installed vs. newly installed

#### Configuration Script (`configure.sh`)
1. **Detects your system** - Identifies your OS and home directory
2. **Backup existing files** - Creates timestamped backups of any existing configuration files
3. **Install configurations** - Copies configuration files to their appropriate locations
4. **Set permissions** - Ensures proper file permissions are applied
5. **Provide feedback** - Shows colored output indicating success, warnings, or errors

### Backup System

When existing configuration files are found, they are automatically backed up with a timestamp:
- Format: `<filename>.backup.YYYYMMDD_HHMMSS`
- Example: `.gitconfig.backup.20250523_143022`

This ensures you never lose your existing configurations and can easily restore them if needed.

### Output Colors

The script uses colored output to make the configuration process clear:
- 🔵 **Blue** - Informational messages
- 🟢 **Green** - Success messages
- 🟡 **Yellow** - Warning messages (like when backups are created)
- 🔴 **Red** - Error messages

## Adding New Components

### Adding New Programs to Install (macOS)
To add new programs to the macOS installation script:

1. Edit `install-macos.sh`
2. Add the package to the `packages` array in the `install_dev_tools()` function
3. Follow the format: `"package-name:Display Name"`

### Adding New Configurations
To add new configuration files:

1. Add the configuration file to this directory
2. Update the `configure.sh` script to include installation logic for the new file
3. Follow the same pattern as the existing `install_gitconfig()` function

## Requirements

### For macOS Installation Script
- **macOS (required)** - This script is designed specifically for macOS
- Internet connection
- Administrator privileges (for Xcode Command Line Tools installation)

### For Configuration Script
- Bash shell
- Standard Unix utilities (`cp`, `chmod`, `date`)
- Write permissions to your home directory

## Compatibility

- ✅ **macOS** (primary target - full support for both installation and configuration)
- 🔄 **Linux** (configuration script only - installation script would need adaptation for different package managers)
- ❓ **Windows** (configuration script may work with WSL or Git Bash, installation script not applicable)

## License

Personal use only - feel free to fork and adapt for your own configurations.
