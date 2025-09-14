#!/bin/bash

source "$(dirname "$0")/utils.sh"

log_step "Installing LSP servers and development tools"

# Install Homebrew
log_info "Installing Homebrew..."
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to PATH for current session
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    log_success "Homebrew installed successfully"
else
    log_info "Homebrew already installed"
fi

# Install Go
log_info "Installing Go..."
if yay -S --noconfirm go; then
    log_success "Go installed successfully"
else
    log_error "Failed to install Go"
fi

# Install Rust
log_info "Installing Rust..."
if yay -S --noconfirm rustup; then
    log_success "Rustup installed successfully"
    log_info "Setting up Rust toolchain..."
    rustup default stable
    log_success "Rust toolchain configured"
else
    log_error "Failed to install Rust"
fi

# Configure npm for user-level global installs
log_info "Configuring npm for user-level global installs..."
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
# Add to PATH for current session
export PATH=~/.npm-global/bin:$PATH

log_info "Installing language servers globally with npm..."

# List of LSP servers to install via npm
lsp_servers=(
    "vscode-langservers-extracted"
    "bash-language-server"
    "@tailwindcss/language-server"
    "@vtsls/language-server"
    "emmet-ls"
)

# Install each LSP server via npm
for server in "${lsp_servers[@]}"; do
    log_info "Installing $server..."
    if npm install -g "$server"; then
        log_success "$server installed successfully"
    else
        log_error "Failed to install $server"
    fi
done

# Install lua-language-server via Homebrew
log_info "Installing lua-language-server via Homebrew..."
if brew install lua-language-server; then
    log_success "lua-language-server installed successfully"
else
    log_error "Failed to install lua-language-server"
fi

# Install gopls for Go
log_info "Installing gopls (Go language server)..."
if go install golang.org/x/tools/gopls@latest; then
    log_success "gopls installed successfully"
else
    log_error "Failed to install gopls"
fi

# Install rust-analyzer
log_info "Installing rust-analyzer..."
if rustup component add rust-analyzer; then
    log_success "rust-analyzer installed successfully"
else
    log_error "Failed to install rust-analyzer"
fi

# Install Claude Code
log_info "Installing Claude Code..."
if npm install -g @anthropic/claude; then
    log_success "Claude Code installed successfully"
else
    log_error "Failed to install Claude Code"
fi

log_success "LSP servers installation complete"
