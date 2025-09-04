#!/bin/bash

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