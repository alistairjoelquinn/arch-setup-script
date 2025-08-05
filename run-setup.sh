#!/bin/bash

# ARCH LINUX SETUP ORCHESTRATOR
# Runs all setup scripts in the correct order

source "$(dirname "$0")/utils.sh"

echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo -e "${WHITE}  🏗️  ARCH LINUX COMPLETE SETUP${NC}"
echo -e "${BLUE}  Automated installation and configuration${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}\n"

SCRIPT_DIR="$(dirname "$0")"

# Run all setup scripts in order
scripts=(
    "01-system-setup.sh"
    "02-dev-tools.sh"
    "03-desktop-env.sh"
    "04-applications.sh"
    "05-shell-dotfiles.sh"
    "06-lsp-servers.sh"
)

for script in "${scripts[@]}"; do
    script_path="$SCRIPT_DIR/$script"
    if [ -f "$script_path" ]; then
        log_step "Running $script"
        chmod +x "$script_path"
        if bash "$script_path"; then
            log_success "$script completed successfully"
        else
            log_error "$script failed"
            echo -e "\n${YELLOW}Setup incomplete. Fix the error and run the script again.${NC}"
            exit 1
        fi
    else
        log_error "Script not found: $script_path"
        exit 1
    fi
done

echo -e "\n${YELLOW}🔄 RESTART REQUIRED:${NC}"
echo -e "   ${WHITE}•${NC} SDDM display manager needs to be activated"
echo -e "   ${WHITE}•${NC} Shell change to zsh needs to take effect"
echo -e "   ${WHITE}•${NC} Hyprland will be available after restart"
echo -e "\n${CYAN}After restart:${NC}"
echo -e "   ${WHITE}•${NC} Log in through SDDM"
echo -e "   ${WHITE}•${NC} Select Hyprland as your session"
echo -e "   ${WHITE}•${NC} Configure waybar and other apps as needed"
echo -e "\n${GREEN}✨ Setup complete! Please restart your system.${NC}"