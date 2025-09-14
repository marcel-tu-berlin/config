#!/usr/bin/env bash

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Function to ensure ngrok shell completions are added to the user's .zshrc (idempotent)
install_ngrok_completion() {
    local home_dir="$(get_home_dir)"
    local zshrc_file="$home_dir/.zshrc"
    local begin_marker="# >>> ngrok completion (config repo) >>>"
    local end_marker="# <<< ngrok completion (config repo) <<<"

    log_info "Configuring ngrok shell completion (zsh)..."

    # If ngrok not installed, skip gracefully
    if ! command_exists ngrok; then
        log_warning "ngrok not found in PATH - skipping completion setup"
        log_info "Install ngrok first, then re-run ./configure.sh to add completions"
        return 0
    fi

    # Create .zshrc if it does not exist
    if [[ ! -f "$zshrc_file" ]]; then
        log_warning ".zshrc not found - creating a new one at $zshrc_file"
        if ! touch "$zshrc_file"; then
            log_error "Failed to create $zshrc_file"
            return 1
        fi
    fi

    # Check if block already present
    if grep -Fqs "$begin_marker" "$zshrc_file"; then
        log_success "ngrok completion block already present in .zshrc"
        return 0
    fi

    # Backup existing .zshrc before modification
    if ! backup_file "$zshrc_file"; then
        log_warning "Proceeding without .zshrc backup (backup failed)"
    fi

    {
        echo "" # ensure newline
        echo "$begin_marker"
        echo "# Automatically added by config repository's configure.sh"
        echo "if command -v ngrok &>/dev/null; then"
        echo "    eval \"$(ngrok completion)\""
        echo "fi"
        echo "$end_marker"
    } >> "$zshrc_file"

    if [[ $? -eq 0 ]]; then
        log_success "ngrok completion added to .zshrc"
        log_info "Reload with: source ~/.zshrc (or open a new terminal)"
        return 0
    else
        log_error "Failed to append ngrok completion to .zshrc"
        return 1
    fi
}

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

# Function to install .tmux.conf
install_tmux_conf() {
    local home_dir="$(get_home_dir)"
    local target_file="$home_dir/.tmux.conf"
    
    log_info "Installing .tmux.conf..."
    
    # Check if target file already exists
    if [[ -f "$target_file" ]]; then
        log_warning "Existing .tmux.conf found at $target_file"
        
        # Create backup
        if ! backup_file "$target_file"; then
            return 1
        fi
    fi
    
    # Create the tmux configuration
    cat > "$target_file" << 'EOF'
# Tmux Plugin Manager (TPM) - Essential plugin manager for tmux
set -g @plugin 'tmux-plugins/tpm'

# Tmux sensible defaults - Basic tmux settings that everyone can agree on
set -g @plugin 'tmux-plugins/tmux-sensible'

# Session persistence plugins
set -g @plugin 'tmux-plugins/tmux-resurrect'  # Save and restore tmux sessions
set -g @plugin 'tmux-plugins/tmux-continuum'  # Continuous saving of tmux environment

# Initialize TPM (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOF
    
    if [[ $? -eq 0 ]]; then
        log_success ".tmux.conf installed successfully to $target_file"
        
        # Set appropriate permissions
        chmod 644 "$target_file"
        log_info "Set permissions (644) for .tmux.conf"
        
        # Reload tmux configuration if tmux is currently running
        if command -v tmux >/dev/null 2>&1 && tmux list-sessions >/dev/null 2>&1; then
            log_info "Tmux is running - reloading configuration..."
            if tmux source "$target_file"; then
                log_success "Tmux configuration reloaded successfully"
            else
                log_warning "Failed to reload tmux configuration, but continuing..."
                log_info "You can manually reload with: tmux source ~/.tmux.conf"
            fi
        else
            log_info "Tmux not running - configuration will be loaded on next tmux start"
        fi
        
        return 0
    else
        log_error "Failed to create .tmux.conf at $target_file"
        return 1
    fi
}

# Main installation function
main() {
    log_info "Starting configuration installation..."
    log_info "Detected OS: $(uname -s)"
    log_info "Home directory: $(get_home_dir)"
    
    # Install .gitconfig
    if ! install_gitconfig; then
        log_error "Installation failed!"
        exit 1
    fi

    # Install .tmux.conf
    if ! install_tmux_conf; then
        log_error "Installation failed!"
        exit 1
    fi

    # Install ngrok completion (non-fatal if it fails)
    if ! install_ngrok_completion; then
        log_warning "ngrok completion setup encountered an issue (continuing)"
    fi
    
    log_success "All configurations installed successfully!"
}

# Run main function
main "$@"


