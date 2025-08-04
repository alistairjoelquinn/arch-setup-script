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

log_step "Installing AUR helper (yay)"
log_info "Cloning yay repository..."
cd ~
git clone https://aur.archlinux.org/yay.git
log_info "Building and installing yay..."
cd yay && makepkg -si --noconfirm
log_info "Cleaning up build files..."
cd .. && rm -rf yay

log_info "Refreshing shell environment..."
hash -r
source /etc/profile

log_info "Testing yay installation..."
if ! command -v yay &> /dev/null; then
    log_error "yay installation failed - command not found"
    exit 1
fi

yay_version=$(yay --version | head -n1)
log_success "AUR helper (yay) installed successfully - $yay_version"

log_step "Installing GitHub CLI"
log_info "Installing GitHub CLI..."
yay -S --noconfirm github-cli
log_success "GitHub CLI installed"

log_step "Installing Hyprland and desktop environment"
log_info "Installing Hyprland compositor and essential components..."
sudo pacman -S --noconfirm --needed hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-kde-agent dunst grim slurp uwsm waybar thunar thunar-archive-plugin thunar-volman tumbler blueberry sddm
log_info "Installing Wayland-compatible applications..."
yay -S --noconfirm --cleanafter --nodiffmenu rofi-wayland
log_info "Enabling SDDM display manager..."
sudo systemctl enable sddm
log_success "Hyprland desktop environment installed"

log_step "Installing applications"
log_info "Installing browsers, development tools, and productivity apps..."
if yay -S --noconfirm --cleanafter firefox ghostty nodejs 1password spotify signal-desktop lazygit neovim obsidian libreoffice-fresh btop fzf ripgrep; then
    log_success "All applications installed successfully"
else
    log_warning "Some applications may have failed to install. Checking individual packages..."
    
    # Check each package individually
    failed_packages=""
    for package in firefox ghostty nodejs 1password spotify signal-desktop lazygit neovim obsidian libreoffice-fresh btop fzf ripgrep; do
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


