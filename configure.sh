#!/usr/bin/env bash

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Function to install .gitconfig
install_gitconfig() {
    local source_file="$SCRIPT_DIR/.gitconfig"
    local home_dir="$(get_home_dir)"
    local target_file="$home_dir/.gitconfig"
    
    log_info "Installing .gitconfig..."
    
    # Check if source file exists
    if [[ ! -f "$source_file" ]]; then
        log_error ".gitconfig not found in $SCRIPT_DIR"
        return 1
    fi
    
    # Check if target file already exists
    if [[ -f "$target_file" ]]; then
        log_warning "Existing .gitconfig found at $target_file"
        
        # Create backup
        if ! backup_file "$target_file"; then
            return 1
        fi
    fi
    
    # Copy the file
    if cp "$source_file" "$target_file"; then
        log_success ".gitconfig installed successfully to $target_file"
        
        # Set appropriate permissions
        chmod 644 "$target_file"
        log_info "Set permissions (644) for .gitconfig"
        
        return 0
    else
        log_error "Failed to copy .gitconfig to $target_file"
        return 1
    fi
}

# Main installation function
main() {
    log_info "Starting configuration installation..."
    log_info "Detected OS: $(uname -s)"
    log_info "Home directory: $(get_home_dir)"
    
    # Install .gitconfig
    if install_gitconfig; then
        log_success "All configurations installed successfully!"
    else
        log_error "Installation failed!"
        exit 1
    fi
}

# Run main function
main "$@"


