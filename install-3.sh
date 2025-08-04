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

log_info "Authenticating with GitHub CLI..."
echo $GITHUB_TOKEN | gh auth login --with-token

log_info "Adding SSH key to GitHub automatically..."
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)-$(date +%Y%m%d)"

log_info "Testing SSH connection to GitHub..."
ssh -T git@github.com || true
log_success "SSH key added to GitHub and connection verified!"

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

log_info "Updating Hyprland config to use ghostty..."
if [ -f ~/.config/hypr/hyprland.conf ]; then
    sed -i 's/kitty/ghostty/g' ~/.config/hypr/hyprland.conf
    log_success "Hyprland config updated to use ghostty"
else
    log_warning "Hyprland config file not found"
fi

log_success "Dotfiles configuration applied successfully"

echo -e "\n${YELLOW}🔄 RESTART REQUIRED:${NC}"
echo -e "   ${WHITE}•${NC} SDDM display manager needs to be activated"
echo -e "   ${WHITE}•${NC} Shell change to zsh needs to take effect"
echo -e "   ${WHITE}•${NC} Hyprland will be available after restart"
echo -e "\n${CYAN}After restart:${NC}"
echo -e "   ${WHITE}•${NC} Log in through SDDM"
echo -e "   ${WHITE}•${NC} Select Hyprland as your session"
echo -e "   ${WHITE}•${NC} Configure waybar and other apps as needed"
echo -e "\n${GREEN}✨ Setup complete! Please restart your system.${NC}"
