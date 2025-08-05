#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_step "Installing LSP servers"
log_info "Installing language servers globally with npm..."

# List of LSP servers to install
lsp_servers=(
    "typescript-language-server"
    "vscode-langservers-extracted"
    "bash-language-server"
    "@tailwindcss/language-server"
    "emmet-ls"
)

# Install each LSP server
for server in "${lsp_servers[@]}"; do
    log_info "Installing $server..."
    if npm install -g "$server"; then
        log_success "$server installed successfully"
    else
        log_error "Failed to install $server"
    fi
done

log_success "LSP servers installation complete"