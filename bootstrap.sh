#!/bin/bash

# ARCH LINUX SETUP BOOTSTRAP
# Downloads the full setup scripts and runs them

# Color definitions for bootstrap
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${CYAN}🚀 Arch Linux Setup Bootstrap${NC}"
echo -e "${WHITE}Downloading setup scripts...${NC}"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and extract the repository
echo -e "${BLUE}Downloading from GitHub...${NC}"
if curl -fsSL https://github.com/alistairjoelquinn/arch-setup-script/archive/main.tar.gz | tar -xz; then
    echo -e "${GREEN}✅ Scripts downloaded successfully${NC}"
else
    echo -e "${RED}❌ Failed to download scripts${NC}"
    exit 1
fi

# Enter the extracted directory
cd arch-setup-script-main

# Make scripts executable
chmod +x *.sh

# Run the main setup
echo -e "${BLUE}Starting setup process...${NC}"
./run-setup.sh

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo -e "${GREEN}🎉 Bootstrap complete!${NC}"