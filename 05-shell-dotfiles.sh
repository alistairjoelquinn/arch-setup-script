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
git clone git@github.com:alistairjoelquinn/dotfiles.git dotfiles-temp
log_info "Copying nvim and ghostty configs..."
cp -r dotfiles-temp/nvim ~/.config/ 2>/dev/null || log_warning "nvim config not found in dotfiles repo"
cp -r dotfiles-temp/ghostty ~/.config/ 2>/dev/null || log_warning "ghostty config not found in dotfiles repo"
log_info "Cleaning up temporary clone..."
rm -rf dotfiles-temp

log_info "Cloning arch-dotfiles repository..."
git clone git@github.com:alistairjoelquinn/arch-dotfiles.git arch-dotfiles-temp
log_info "Copying arch-specific configs (zshrc, hyprland, tmux)..."
cp -r arch-dotfiles-temp/. ~/.config/
sleep 2
log_info "Force copying zshrc to ensure it overwrites Oh My Zsh config..."
cp -f arch-dotfiles-temp/.zshrc ~/.config/.zshrc
log_info "Cleaning up arch dotfiles clone..."
rm -rf arch-dotfiles-temp

log_info "Setting up git remote for .config directory..."
cd ~/.config
git init
git branch -m main
git remote add origin git@github.com:alistairjoelquinn/arch-dotfiles.git

# Create the fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts/dank-mono

# Copy all font files from your config directory
cp ~/.config/files/DankMono/OpenType-PS/* ~/.local/share/fonts/dank-mono/
cp ~/.config/files/DankMono/OpenType-TT/* ~/.local/share/fonts/dank-mono/
cp ~/.config/files/DankMono/Web-PS/* ~/.local/share/fonts/dank-mono/

# Refresh font cache
fc-cache -fv

log_info "Creating symlinks..."
ln -sf ~/.config/.zshrc ~/.zshrc
ln -sf ~/.config/tmux.conf ~/.tmux.conf

log_info "Setting up mimeapps.list for default image applications..."
cat > ~/.config/mimeapps.list << 'EOF'
[Default Applications]
image/jpeg=imv.desktop
image/jpg=imv.desktop
image/png=imv.desktop
image/gif=imv.desktop
image/webp=imv.desktop
image/bmp=imv.desktop
image/tiff=imv.desktop
image/svg+xml=imv.desktop

[Added Associations]
image/jpeg=imv.desktop
image/png=imv.desktop
image/gif=imv.desktop
EOF

log_success "Dotfiles configuration applied successfully"
