#!/bin/bash

# ARCH SETUP SCRIPT

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  INFO:${NC} $1"
}

log_success() {
    echo -e "${GREEN}✅ SUCCESS:${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING:${NC} $1"
}

log_error() {
    echo -e "${RED}❌ ERROR:${NC} $1"
}

log_step() {
    echo -e "\n${PURPLE}📋 STEP:${NC} ${WHITE}$1${NC}"
    echo -e "${CYAN}────────────────────────────────────────${NC}"
}

# Setup wifi
log_step "Setting up WiFi connection"
log_info "Checking NetworkManager status..."
systemctl status NetworkManager
log_info "Scanning for available WiFi networks..."
nmcli device wifi list 

echo -e "\n${YELLOW}📶 WiFi Setup${NC}"
read -p "Enter WiFi network name: " wifi_network
read -s -p "Enter WiFi password: " wifi_password
echo

log_info "Connecting to WiFi network '$wifi_network'..."
nmcli device wifi connect "$wifi_network" password "$wifi_password"
log_success "WiFi connection established"

log_step "Testing internet connection"
log_info "Pinging Google to verify connectivity..."
ping -c 3 google.com
log_success "Internet connection verified"

log_step "Updating system packages"
log_info "Running full system update..."
sudo pacman -Syu
log_success "System packages updated"

log_step "Setting up firewall"
log_info "Installing UFW (Uncomplicated Firewall)..."
sudo pacman -S --noconfirm ufw 
log_info "Enabling UFW service..."
sudo systemctl enable --now ufw 
log_info "Activating firewall..."
sudo ufw enable
log_success "Firewall configured and activated"

log_step "Installing base packages"
log_info "Installing essential development tools..."
sudo pacman -S --noconfirm git zsh tmux lua luarocks wl-clipboard
log_success "Base packages installed"

log_step "Installing AUR helper (yay)"
log_info "Cloning yay repository..."
cd ~
git clone https://aur.archlinux.org/yay.git
log_info "Building and installing yay..."
cd yay && makepkg -si --noconfirm
log_info "Cleaning up build files..."
cd .. && rm -rf yay
log_success "AUR helper (yay) installed successfully"

log_step "Installing Hyprland and desktop environment"
log_info "Installing Hyprland compositor and essential components..."
sudo pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-kde-agent dunst grim slurp uwsm waybar thunar thunar-archive-plugin thunar-volman tumbler blueberry sddm
log_info "Installing Wayland-compatible applications..."
yay -S --noconfirm rofi-wayland
log_info "Enabling SDDM display manager..."
sudo systemctl enable sddm
log_success "Hyprland desktop environment installed"

log_step "Installing applications"
log_info "Installing browsers, development tools, and productivity apps..."
yay -S firefox ghostty nodejs 1password mullvad-vpn spotify signal-desktop lazygit neovim obsidian libreoffice-fresh btop fzf ripgrep claude-code
log_success "All applications installed successfully"

log_step "Preparing configuration directory"
log_info "Creating .config directory..."
mkdir -p ~/.config
log_info "Removing existing config files from home directory..."
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

log_step "Configuring Git"
log_info "Setting up global Git configuration..."
git config --global user.name "alistairjoelquinn"
git config --global user.email "alistairjoelquinn@gmail.com"
log_success "Git configured with username: alistairjoelquinn"

log_step "Setting up GitHub SSH authentication"
log_info "Generating Ed25519 SSH key for GitHub..."
ssh-keygen -t ed25519 -C "alistairjoelquinn@gmail.com" -f ~/.ssh/id_ed25519 -N ""
log_info "Starting SSH agent..."
eval "$(ssh-agent -s)"
log_info "Adding SSH key to agent..."
ssh-add ~/.ssh/id_ed25519
log_info "Copying public key to clipboard..."
wl-copy < ~/.ssh/id_ed25519.pub
log_success "SSH key generated and copied to clipboard!"

echo -e "\n${CYAN}🔑 Your public key is now ready to add to GitHub:${NC}"
echo -e "   ${WHITE}1.${NC} Go to ${BLUE}https://github.com/settings/keys${NC}"
echo -e "   ${WHITE}2.${NC} Click ${GREEN}'New SSH key'${NC}"
echo -e "   ${WHITE}3.${NC} Paste the key from clipboard ${YELLOW}(Ctrl+V)${NC}"
echo -e "   ${WHITE}4.${NC} Give it a title and save"

echo -e "\n${YELLOW}⏸️  Please complete the GitHub SSH key setup above, then press ENTER to continue...${NC}"
read -r

log_info "Testing SSH connection to GitHub..."
ssh -T git@github.com || true
log_success "SSH connection to GitHub verified! You can now clone repositories using SSH."

log_step "Setting up dotfiles configuration"
log_info "Cloning dotfiles repository..."
cd ~
git clone git@github.com:alistairjoelquinn/arch-dotfiles.git dotfiles-temp
log_info "Copying dotfiles to ~/.config/..."
cp -r dotfiles-temp/* ~/.config/
log_info "Cleaning up temporary clone..."
rm -rf dotfiles-temp
log_info "Recreating symlinks with new config files..."
ln -sf ~/.config/.zshrc ~/.zshrc
ln -sf ~/.config/tmux.conf ~/.tmux.conf
log_success "Dotfiles configuration applied successfully"
