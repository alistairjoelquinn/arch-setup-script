#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_step "Installing Hyprland and desktop environment"
log_info "Installing Hyprland compositor and essential components..."
sudo pacman -S --noconfirm --needed hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-kde-agent dunst grim slurp uwsm waybar thunar thunar-archive-plugin thunar-volman tumbler blueberry sddm
log_info "Installing Wayland-compatible applications..."
yay -S --noconfirm --cleanafter --nodiffmenu rofi-wayland
log_info "Enabling SDDM display manager..."
sudo systemctl enable sddm
log_success "Hyprland desktop environment installed"