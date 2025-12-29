#!/usr/bin/env bash
#
# dotfiles setup script
# Interactive installation with yes/no prompts for each component
# Works with fresh installs and partially configured systems
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Track what was done
ACTIONS_PERFORMED=()
ACTIONS_SKIPPED=()
ACTIONS_ALREADY_SETUP=()

# Print colored messages
print_header() {
    echo -e "\n${BOLD}${CYAN}==>${NC} ${BOLD}$1${NC}"
}

print_info() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_question() {
    echo -e "${MAGENTA}?${NC} ${BOLD}$1${NC}"
}

# Ask yes/no question
ask_yn() {
    local prompt="$1"
    local default="${2:-n}"
    local yn

    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    while true; do
        print_question "$prompt"
        read -r yn
        yn=${yn:-$default}
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"

    # Check if target already points to source
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        print_success "$description - Already configured"
        ACTIONS_ALREADY_SETUP+=("$description")
        return 0
    fi

    # Check if target exists (file or broken symlink)
    if [ -e "$target" ] || [ -L "$target" ]; then
        print_warning "$description - Target already exists: $target"
        if ask_yn "  Backup existing file and create symlink?"; then
            local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$target" "$backup"
            print_info "  Backed up to: $backup"
            ln -s "$source" "$target"
            print_success "  Symlink created: $target -> $source"
            ACTIONS_PERFORMED+=("$description (backed up existing)")
            return 0
        else
            print_info "  Skipped"
            ACTIONS_SKIPPED+=("$description")
            return 1
        fi
    fi

    # Create parent directory if needed
    local target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        print_info "  Created directory: $target_dir"
    fi

    # Create symlink
    ln -s "$source" "$target"
    print_success "  Symlink created: $target -> $source"
    ACTIONS_PERFORMED+=("$description")
    return 0
}

# Setup component
setup_component() {
    local source="$1"
    local target="$2"
    local name="$3"
    local description="$4"

    print_header "$name"
    print_info "$description"

    if ask_yn "Setup $name?"; then
        create_symlink "$source" "$target" "$name"
    else
        print_info "Skipped $name"
        ACTIONS_SKIPPED+=("$name")
    fi
}

# Print summary
print_summary() {
    print_header "Setup Summary"

    if [ ${#ACTIONS_PERFORMED[@]} -gt 0 ]; then
        echo -e "\n${GREEN}${BOLD}Configured (${#ACTIONS_PERFORMED[@]}):${NC}"
        for action in "${ACTIONS_PERFORMED[@]}"; do
            echo -e "  ${GREEN}✓${NC} $action"
        done
    fi

    if [ ${#ACTIONS_ALREADY_SETUP[@]} -gt 0 ]; then
        echo -e "\n${CYAN}${BOLD}Already Setup (${#ACTIONS_ALREADY_SETUP[@]}):${NC}"
        for action in "${ACTIONS_ALREADY_SETUP[@]}"; do
            echo -e "  ${CYAN}✓${NC} $action"
        done
    fi

    if [ ${#ACTIONS_SKIPPED[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}${BOLD}Skipped (${#ACTIONS_SKIPPED[@]}):${NC}"
        for action in "${ACTIONS_SKIPPED[@]}"; do
            echo -e "  ${YELLOW}−${NC} $action"
        done
    fi

    echo ""
}

# Main setup
main() {
    # Welcome banner
    echo -e "${BOLD}${CYAN}"
    echo "╔════════════════════════════════════════╗"
    echo "║                                        ║"
    echo "║       Dotfiles Setup Script            ║"
    echo "║                                        ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"

    print_info "This script will help you set up your dotfiles configuration."
    print_info "You'll be asked for confirmation before each change."
    echo ""

    # Get dotfiles directory
    DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    print_info "Dotfiles directory: $DOTFILES_DIR"
    echo ""

    # Check/Install Antigen (required for Zsh configuration)
    print_header "Antigen Plugin Manager"
    print_info "Antigen is required for zsh plugins and will be installed to ~/.antigen"

    if [ -d "$HOME/.antigen" ]; then
        print_success "Antigen already installed at ~/.antigen"
        ACTIONS_ALREADY_SETUP+=("Antigen plugin manager")
    else
        if ask_yn "Clone Antigen to ~/.antigen?" "y"; then
            print_info "Cloning Antigen..."
            git clone https://github.com/zsh-users/antigen.git "$HOME/.antigen"
            print_success "Antigen installed to ~/.antigen"
            ACTIONS_PERFORMED+=("Antigen plugin manager")
        else
            print_warning "Skipped Antigen - Zsh configuration may not work correctly"
            ACTIONS_SKIPPED+=("Antigen plugin manager")
        fi
    fi

    # Zsh shell configuration
    setup_component \
        "$DOTFILES_DIR/zshrc" \
        "$HOME/.zshrc" \
        "Zsh Configuration" \
        "Shell configuration with Antigen, LiquidPrompt, custom aliases, and PATH setup"

    # Vim configuration (classic)
    setup_component \
        "$DOTFILES_DIR/vimrc" \
        "$HOME/.vimrc" \
        "Vim Configuration" \
        "Classic vim with Vundle plugins, CtrlP, YouCompleteMe, ALE linter, and desert theme"

    # Neovim configuration (modern)
    setup_component \
        "$DOTFILES_DIR/.config/nvim" \
        "$HOME/.config/nvim" \
        "Neovim Configuration" \
        "Modern nvim with lazy.nvim, Telescope fuzzy finder, and Ghostty terminal colors"

    # Powerline configuration
    setup_component \
        "$DOTFILES_DIR/.config/powerline" \
        "$HOME/.config/powerline" \
        "Powerline Configuration" \
        "Powerline prompt theme and colors"

    # Tmux configuration
    setup_component \
        "$DOTFILES_DIR/tmux.conf" \
        "$HOME/.tmux.conf" \
        "Tmux Configuration" \
        "Terminal multiplexer configuration with custom key bindings"

    # Mercurial configuration
    setup_component \
        "$DOTFILES_DIR/hgrc" \
        "$HOME/.hgrc" \
        "Mercurial Configuration" \
        "Mercurial version control settings"

    # GHCi (Haskell REPL) configuration
    setup_component \
        "$DOTFILES_DIR/ghci" \
        "$HOME/.ghci" \
        "GHCi Configuration" \
        "Haskell REPL customization"

    # Post-setup instructions
    print_header "Post-Setup Instructions"

    if [[ " ${ACTIONS_PERFORMED[@]} " =~ "Antigen plugin manager" ]] || [[ " ${ACTIONS_ALREADY_SETUP[@]} " =~ "Antigen plugin manager" ]]; then
        print_info "Antigen: Installed at ~/.antigen (zsh plugins will auto-install on first shell launch)"
    fi

    if [[ " ${ACTIONS_PERFORMED[@]} " =~ "Zsh Configuration" ]]; then
        print_info "Zsh: Run 'source ~/.zshrc' to load configuration (plugins auto-install)"
    fi

    if [[ " ${ACTIONS_PERFORMED[@]} " =~ "Vim Configuration" ]]; then
        print_info "Vim: Install Vundle plugins with:"
        echo "  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
        echo "  vim +PluginInstall +qall"
    fi

    if [[ " ${ACTIONS_PERFORMED[@]} " =~ "Neovim Configuration" ]]; then
        print_info "Neovim: Launch 'nvim' to auto-install plugins, then press Ctrl-P!"
    fi

    # Print summary
    print_summary

    # Final message
    print_header "Setup Complete!"
    print_success "Your dotfiles are ready to use!"
    echo ""
}

# Run main
main
