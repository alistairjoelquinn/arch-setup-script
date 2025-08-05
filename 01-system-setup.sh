#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_step "Testing internet connection"
log_info "Verifying internet connectivity..."
ping -c 3 google.com
log_success "Internet connection verified"

log_step "Updating system packages"
log_info "Running full system update..."
sudo pacman -Syu
log_success "System packages updated"

log_step "Setting up firewall"
log_info "Installing UFW (Uncomplicated Firewall)..."
sudo pacman -S --noconfirm --needed ufw 
log_info "Enabling UFW service..."
sudo systemctl enable --now ufw 
log_info "Activating firewall..."
sudo ufw enable
log_success "Firewall configured and activated"

log_step "Installing base packages"
log_info "Installing essential development tools..."
sudo pacman -S --noconfirm --needed git zsh tmux lua luarocks wl-clipboard openssh inetutils
log_success "Base packages installed"