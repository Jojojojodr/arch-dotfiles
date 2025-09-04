#!/bin/bash
# This script sets up the Arch Linux environment with essential packages, services, and configurations.

titleBar() {
    cat << "EOF"
|===============================================|
|---  Setting up the arch linux environment  ---|
|===============================================|
EOF
}

DEV_ONLY=false
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --dev-only)
            DEV_ONLY=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

set -e

clear
titleBar

source ./utils.sh  # Load utility functions
source ./zsh.sh  # Load zsh installation script
source ./packages.conf  # Load package list

# Update package list
sudo pacman -Syu --noconfirm

# Install yay
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S base-devel git --noconfirm
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si --noconfirm
    cd ~/ && rm -rf yay
else
    echo "yay is already installed."
fi

# Install system packages
echo "Installing system packages..."
install_packages "${SYSTEM_PACKAGES[@]}"

# Install development packages
echo "Installing development packages..."
install_packages "${DEV_PACKAGES[@]}"

if [[ "$DEV_ONLY" == true ]]; then
    echo "Development-only mode enabled. Skipping additional packages."
else
    echo "Installing desktop packages..."
    install_packages "${DESKTOP_PACKAGES[@]}"
    
    xdg-user-dirs-update

    # Install additional packages
    echo "Installing additional packages..."
    install_packages "${ADDITIONAL_PACKAGES[@]}"  
fi

# Install zsh and oh-my-zsh
echo "Installing zsh and oh-my-zsh..."
install_zsh

# Create symlinks for dotfiles
echo "Creating symlinks for dotfiles..."
cd ~/dotfiles

rm -f ~/.zshrc  # Remove existing .zshrc to avoid conflicts
stow --adopt zsh
stow --adopt git
stow --adopt nvim

if [[ "$DEV_ONLY" == true ]]; then
    echo "Development-only mode enabled. Skipping additional dotfiles."
else
    stow --adopt hypr
    stow --adopt kitty
    stow --adopt waybar
    stow --adopt rofi
    stow --adopt ranger
fi

# Add user to docker group
if ! groups $USER | grep -q "\bdocker\b"; then
    echo "Adding user to docker group..."
    sudo usermod -aG docker $(whoami)
else
    echo "User is already in the docker group."
fi

echo "Development environment setup complete."
echo "Please reboot your system to apply all changes."