#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_step "Preparing configuration directory"
log_info "Creating .config directory..."
mkdir -p ~/.config
log_info "Removing existing .tmux.conf..."
rm -f ~/.tmux.conf
log_success "Configuration directory prepared"

log_step "Changing default shell"
log_info "Setting zsh as default shell..."
chsh -s /usr/bin/zsh 
log_success "Default shell changed to zsh"

log_step "Installing Oh My Zsh"
log_info "Downloading and installing Oh My Zsh framework..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
log_info "Moving Oh My Zsh config to ~/.config and recreating symlink..."
mv ~/.zshrc ~/.config/.zshrc
ln -sf ~/.config/.zshrc ~/.zshrc
log_success "Oh My Zsh installed successfully"

log_step "Setting up dotfiles configuration"
log_info "Cloning dotfiles repository..."
cd ~
git clone git@github.com:alistairjoelquinn/arch-dotfiles.git dotfiles-temp
log_info "Copying dotfiles to ~/.config/ (excluding zshrc)..."
cp -r dotfiles-temp/* ~/.config/
rm -f ~/.config/.zshrc
log_info "Cleaning up temporary clone..."
rm -rf dotfiles-temp

log_info "Setting up Arch-specific zshrc..."
SCRIPT_DIR="$(dirname "$0")"
cp "$SCRIPT_DIR/zshrc" ~/.config/.zshrc

log_info "Creating symlinks..."
ln -sf ~/.config/.zshrc ~/.zshrc
ln -sf ~/.config/tmux.conf ~/.tmux.conf

log_info "Updating Hyprland config to use ghostty..."
if [ -f ~/.config/hypr/hyprland.conf ]; then
    sed -i 's/kitty/ghostty/g' ~/.config/hypr/hyprland.conf
    log_success "Hyprland config updated to use ghostty"
else
    log_warning "Hyprland config file not found"
fi

log_success "Dotfiles configuration applied successfully"