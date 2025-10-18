#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_step "Installing Hyprland and desktop environment"
log_info "Installing Hyprland compositor and essential components..."
sudo pacman -S --noconfirm --needed hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-kde-agent uwsm waybar nautilus blueberry sddm hypridle hyprlock hyprpaper noto-fonts-emoji imv
log_info "Installing Wayland-compatible applications..."
yay -S --noconfirm --cleanafter hyprshot swaync
log_info "Enabling SDDM display manager..."
sudo systemctl enable sddm
log_success "Hyprland desktop environment installed"
log_info "Adding nerd font for waybar"
sudo pacman -S ttf-font-awesome ttf-nerd-fonts-symbols-mono
log_success "Added nerd fonts"
