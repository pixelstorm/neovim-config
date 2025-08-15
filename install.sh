#!/bin/bash

#╭─────────────────────────────────────────────────────────────╮
#│                    Neovim Config Installer                  │
#│                                                             │
#│  Quick installation script for the Neovim configuration    │
#╰─────────────────────────────────────────────────────────────╯

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation function
main() {
    echo -e "${BLUE}"
    echo "╭─────────────────────────────────────────────────────────────╮"
    echo "│                 Neovim Configuration 2025                  │"
    echo "│                     Installation Script                    │"
    echo "╰─────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"

    # Check prerequisites
    print_status "Checking prerequisites..."

    if ! command_exists nvim; then
        print_error "Neovim is not installed. Please install Neovim >= 0.9.0"
        exit 1
    fi

    if ! command_exists git; then
        print_error "Git is not installed. Please install Git"
        exit 1
    fi

    if ! command_exists node; then
        print_warning "Node.js not found. Some features may not work properly"
    fi

    if ! command_exists rg; then
        print_warning "ripgrep not found. Install it for better search performance"
    fi

    print_success "Prerequisites check completed"

    # Backup existing config
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        print_status "Backing up existing Neovim configuration..."
        BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        print_success "Backup created at $BACKUP_DIR"
    fi

    # Create config directory
    print_status "Creating Neovim configuration directory..."
    mkdir -p "$NVIM_CONFIG_DIR"

    # Copy configuration files
    print_status "Installing configuration files..."
    cp -r ./* "$NVIM_CONFIG_DIR/"
    print_success "Configuration files installed"

    # Set executable permissions
    chmod +x "$NVIM_CONFIG_DIR/install.sh" 2>/dev/null || true

    print_success "Installation completed!"
    echo
    print_status "Next steps:"
    echo "  1. Start Neovim: nvim"
    echo "  2. Wait for plugins to install automatically"
    echo "  3. Run :checkhealth to verify installation"
    echo "  4. For Copilot: run :Copilot auth"
    echo
    print_status "For more information, see the README.md file"
}

# Run main function
main "$@"