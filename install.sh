#!/usr/bin/env bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get the home directory path
get_home_dir() {
    echo "$HOME"
}

# Function to create backup of existing file
backup_file() {
    local file_path="$1"
    local backup_path="${file_path}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if cp "$file_path" "$backup_path"; then
        log_warning "Existing file backed up to: $backup_path"
        return 0
    else
        log_error "Failed to create backup of $file_path"
        return 1
    fi
}

# Function to install .gitconfig
install_gitconfig() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local source_file="$script_dir/.gitconfig"
    local home_dir="$(get_home_dir)"
    local target_file="$home_dir/.gitconfig"
    
    log_info "Installing .gitconfig..."
    
    # Check if source file exists
    if [[ ! -f "$source_file" ]]; then
        log_error ".gitconfig not found in $script_dir"
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


