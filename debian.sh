#!/usr/bin/env bash

titleBar() {
    cat << "EOF"
|=============================================================|
|---  Setting up the system for a Debian/Ubuntu environment  ---|
|=============================================================|
EOF
}

update_system() {
    echo "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
}

is_installed() {
    dpkg -l | grep -qw "$1"
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
        sudo apt install -y "${to_install[@]}"
    fi
}

install_system() {
    local dev_only="$1"
    
    # Install system packages
    echo "Installing system packages..."
    install_packages "${SYSTEM_PACKAGES[@]}"

    # Install development packages
    echo "Installing development packages..."
    install_packages "${DEV_PACKAGES[@]}"

    if [ "$dev_only" = true ]; then
        echo "Development-only mode enabled. Skipping additional packages."
    else
        echo "Installing desktop packages..."
        install_packages "${DESKTOP_PACKAGES[@]}"

        xdg-user-dirs-update

        # install additional packages
        install_packages "${ADDITIONAL_PACKAGES[@]}"
    fi
}

