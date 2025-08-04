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

log_step "GitHub Token Setup"
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "\n${CYAN}🔑 GitHub Authentication Required:${NC}"
    echo -e "   ${WHITE}Get a token from:${NC} ${BLUE}https://github.com/settings/tokens${NC}"
    echo -e "   ${WHITE}Required scopes:${NC} ${YELLOW}write:public_key, read:user${NC}"
    echo ""
    
    echo -n "Enter your GitHub token: "
    read -r GITHUB_TOKEN < /dev/tty
    
    if [ -z "$GITHUB_TOKEN" ]; then
        log_error "No token entered. Script cannot continue without GitHub token."
        exit 1
    fi
    
    export GITHUB_TOKEN
    echo -e "${GREEN}✅ Token set successfully: ${GITHUB_TOKEN}${NC}"
fi

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
