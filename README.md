# System Configuration

A reusable configuration management system for setting up development environments across macOS and Linux systems.

## Purpose

This repository contains my personal system configurations and an automated installation script to quickly set up new machines or synchronize configurations across multiple development environments. The goal is to maintain consistency and save time when configuring new systems.

## Features

- 🔧 Automated installation of configuration files
- 💾 Automatic backup of existing configurations
- 🎨 Colored terminal output for clear feedback
- 🔒 Safe installation with backup protection
- 🖥️ Cross-platform support (macOS & Linux)

## Current Configurations

- **Git Configuration** (`.gitconfig`) - Git user settings, aliases, and preferences

## Usage

### Quick Start

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd config
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

### What the Install Script Does

The installation script will:

1. **Detect your system** - Identifies your OS and home directory
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

The script uses colored output to make the installation process clear:
- 🔵 **Blue** - Informational messages
- 🟢 **Green** - Success messages
- 🟡 **Yellow** - Warning messages (like when backups are created)
- 🔴 **Red** - Error messages

## Adding New Configurations

To add new configuration files:

1. Add the configuration file to this directory
2. Update the `install.sh` script to include installation logic for the new file
3. Follow the same pattern as the existing `install_gitconfig()` function

## Requirements

- Bash shell
- Standard Unix utilities (`cp`, `chmod`, `date`)
- Write permissions to your home directory

## Compatibility

- ✅ macOS
- ✅ Linux
- ❓ Windows (untested, may work with WSL or Git Bash)

## License

Personal use only - feel free to fork and adapt for your own configurations.
