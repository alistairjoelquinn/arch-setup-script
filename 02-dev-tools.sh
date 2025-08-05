#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_step "GitHub Token Setup"
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "\n${CYAN}🔑 GitHub Authentication Required:${NC}"
    echo -e "   ${WHITE}Get a token from:${NC} ${BLUE}https://github.com/settings/tokens${NC}"
    echo -e "   ${WHITE}Required scopes:${NC} ${YELLOW}write:public_key, read:user${NC}"
    echo ""
    
    echo -n "Enter your GitHub token: "
    read -rs GITHUB_TOKEN < /dev/tty
    echo ""
    
    if [ -z "$GITHUB_TOKEN" ]; then
        log_error "No token entered. Script cannot continue without GitHub token."
        exit 1
    fi
    
    export GITHUB_TOKEN
    log_success "Token configured successfully"
fi

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

log_success "SSH key added to GitHub successfully!"
log_info "You can test the connection later with: ssh -T git@github.com"