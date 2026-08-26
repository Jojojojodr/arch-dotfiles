#!/usr/bin/env bash

titleBar() {
    cat << "EOF"
|=============================================================|
|---  Setting up the system for an Arch Linux environment  ---|
|=============================================================|
EOF
}

update_system() {
    echo "Updating system packages..."
    sudo pacman -Syu --noconfirm
}

install_yay() {
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
}

is_installed() {
    yay -Qi "$1" &> /dev/null
}

is_group_installed() {
    yay -Qg "$1" &> /dev/null
}

install_packages() {
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        else
            echo "Package '$pkg' is already installed."
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        echo "Installing packages: ${to_install[*]}"
        for pkg in "${to_install[@]}"; do
            if is_group_installed "$pkg"; then
                echo "Installing group package: $pkg"
                yay -S --noconfirm "$pkg"
            else
                echo "Installing package: $pkg"
                yay -S --noconfirm "$pkg"
            fi
        done
    else
        echo "All specified packages are already installed."
    fi
}

install_system() {
    local dev_only="$1"
    
    # Install yay
    install_yay

    # Install system packages
    echo "Installing system packages..."
    install_packages "${SYSTEM_PACKAGES[@]}"

    # Install development packages
    echo "Installing development packages..."
    install_packages "${DEV_PACKAGES[@]}"

    if [[ "$dev_only" == true ]]; then
        echo "Development-only mode enabled. Skipping additional packages."
    else
        echo "Installing desktop packages..."
        install_packages "${DESKTOP_PACKAGES[@]}"
        
        xdg-user-dirs-update

        # Install additional packages
        echo "Installing additional packages..."
        install_packages "${ADDITIONAL_PACKAGES[@]}"

        # Install AUR packages
        echo "Installing AUR packages..."
        install_packages "${AUR_PACKAGES[@]}"
    fi
}