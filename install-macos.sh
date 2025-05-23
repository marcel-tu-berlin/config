#!/usr/bin/env bash

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Function to install Xcode Command Line Tools
install_xcode_tools() {
    log_info "Checking Xcode Command Line Tools..."
    
    if xcode-select -p >/dev/null 2>&1; then
        log_success "Xcode Command Line Tools already installed"
        return 0
    fi
    
    log_info "Installing Xcode Command Line Tools..."
    log_warning "This will open a dialog box - please follow the installation prompts"
    
    if xcode-select --install; then
        log_info "Xcode Command Line Tools installation initiated"
        log_warning "Please complete the installation in the dialog box before continuing"
        log_warning "Once installation is complete, you may need to run this script again"
        return 0
    else
        log_error "Failed to start Xcode Command Line Tools installation"
        return 1
    fi
}

# Function to install Homebrew
install_homebrew() {
    log_info "Checking Homebrew installation..."
    
    if command_exists brew; then
        log_success "Homebrew already installed at $(which brew)"
        # Update Homebrew
        log_info "Updating Homebrew..."
        if brew update; then
            log_success "Homebrew updated successfully"
        else
            log_warning "Failed to update Homebrew, but continuing..."
        fi
        return 0
    fi
    
    log_info "Installing Homebrew..."
    log_warning "This will download and install Homebrew from GitHub"
    
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        log_success "Homebrew installed successfully"
        
        # Add Homebrew to PATH for current session if on Apple Silicon Mac
        if is_macos && [[ "$(uname -m)" == "arm64" ]]; then
            log_info "Adding Homebrew to PATH for Apple Silicon Mac..."
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        return 0
    else
        log_error "Failed to install Homebrew"
        return 1
    fi
}

# Function to install a package via Homebrew
install_brew_package() {
    local package="$1"
    local display_name="${2:-$package}"
    
    log_info "Checking $display_name..."
    
    # Check if already installed via Homebrew
    if brew list "$package" >/dev/null 2>&1; then
        log_success "$display_name already installed via Homebrew"
        return 0
    fi
    
    # Check if command exists (might be installed via other means)
    if command_exists "$package"; then
        log_warning "$display_name found in PATH but not installed via Homebrew"
        log_info "Installing via Homebrew for consistency..."
    else
        log_info "$display_name not found - installing via Homebrew..."
    fi
    
    if brew install "$package"; then
        log_success "$display_name installed successfully"
        return 0
    else
        log_error "Failed to install $display_name"
        return 1
    fi
}

# Function to install all development tools
install_dev_tools() {
    local failed_installations=()
    
    log_info "Installing development tools..."
    
    # Install each package
    local packages=(
        "ghostty:Ghostty Terminal"
        "tmux:tmux"
        "git:Git"
    )
    
    for package_info in "${packages[@]}"; do
        local package="${package_info%%:*}"
        local display_name="${package_info##*:}"
        
        if ! install_brew_package "$package" "$display_name"; then
            failed_installations+=("$display_name")
        fi
    done
    
    # Report results
    if [[ ${#failed_installations[@]} -eq 0 ]]; then
        log_success "All development tools installed successfully!"
        return 0
    else
        log_error "Failed to install: ${failed_installations[*]}"
        return 1
    fi
}

# Main installation function
main() {
    log_info "Starting system installation..."
    log_info "Detected OS: $(uname -s) $(uname -m)"
    log_info "Home directory: $(get_home_dir)"
    
    # Check if running on macOS
    if ! is_macos; then
        log_error "This installation script is designed for macOS only"
        log_info "For Linux systems, please adapt the script to use your package manager"
        exit 1
    fi
    
    local exit_code=0
    
    # Install Xcode Command Line Tools
    if ! install_xcode_tools; then
        log_error "Xcode Command Line Tools installation failed"
        exit_code=1
    fi
    
    # Install Homebrew
    if ! install_homebrew; then
        log_error "Homebrew installation failed"
        exit_code=1
    fi
    
    # Install development tools (only if Homebrew is available)
    if command_exists brew; then
        if ! install_dev_tools; then
            log_error "Some development tools failed to install"
            exit_code=1
        fi
    else
        log_error "Homebrew not available - skipping development tools installation"
        exit_code=1
    fi
    
    if [[ $exit_code -eq 0 ]]; then
        log_success "System installation completed successfully!"
        log_info "You may need to restart your terminal or run 'source ~/.zshrc' to use new tools"
    else
        log_error "Installation completed with some errors"
        log_info "Please review the error messages above and re-run the script if needed"
    fi
    
    exit $exit_code
}

# Run main function
main "$@"


