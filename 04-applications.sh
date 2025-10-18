#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_step "Installing applications"
log_info "Installing browsers, development tools, and productivity apps..."
if yay -S --noconfirm --cleanafter firefox ghostty nodejs 1password spotify signal-desktop slack-desktop gnome-calculator font-manager pavucontrol lazygit neovim obsidian libreoffice-fresh btop fzf ripgrep walker elephant elephant-desktopapplications elephant-emojis elephant-providerlist elephant-symbols elephant-hyprlandkeybinds elephant-calc elephant-unicode; then
    log_success "All applications installed successfully"
else
    log_warning "Some applications may have failed to install. Checking individual packages..."
    
    failed_packages=""
    for package in firefox ghostty nodejs 1password spotify signal-desktop slack-desktop gnome-calculator font-manager pavucontrol lazygit neovim obsidian libreoffice-fresh btop fzf ripgrep walker elephant elephant-desktopapplications elephant-providerlist elephant-emojis elephant-symbols elephant-hyprlandkeybinds elephant-calc elephant-unicode; do
        if pacman -Q "$package" &>/dev/null; then
            log_success "$package - installed ✓"
        else
            log_error "$package - FAILED ✗"
            failed_packages="$failed_packages $package"
        fi
    done
    
    if [ -n "$failed_packages" ]; then
        log_warning "Failed packages:$failed_packages"
        echo -e "\n${YELLOW}You can try installing failed packages manually later with:${NC}"
        echo -e "${WHITE}yay -S$failed_packages${NC}"
    fi
fi

log_step "Installing Claude Code"
log_info "Installing Claude Code CLI via npm..."
if npm install -g @anthropic/claude; then
    log_success "Claude Code installed successfully"
else
    log_error "Failed to install Claude Code"
fi
