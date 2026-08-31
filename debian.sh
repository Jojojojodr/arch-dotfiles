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

install_desktop_stack() {
    # install dependenties
    install_packages "${DEB_DESKTOP_DEPENDENCIES_PACKAGES[@]}"

    # create work directory
    cd ~
    mkdir install-hyprland
    cd install-hyprland

    # install hyprland
    git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    make all && sudo make install
    cd ..

    # install hyprpaper
    git clone --recursive https://github.com/hyprwm/hyprpaper
    cd hyprpaper
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    cmake --install ./build
    cd ..

    # install hyprpicker
    git clone --recursive https://github.com/hyprwm/hyprpicker
    cd hyprpicker
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target hyprpicker -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    cmake --install ./build
    cd ..

    # install hyprshot
    git clone https://github.com/Gustash/hyprshot.git Hyprshot
    ln -s $(pwd)/Hyprshot/hyprshot $HOME/.local/bin
    chmod +x Hyprshot/hyprshot

    # install hyprlock
    git clone --recursive https://github.com/hyprwm/hyprlock
    cd hyprlock
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
    cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    sudo cmake --install build
    cd ..

    # install wayle
    git clone https://github.com/wayle-rs/wayle
    cd wayle
    cargo install --path wayle
    cargo install --path crates/wayle-settings
    wayle icons setup
}

install_system() {
    local dev_only="$1"
    
    # Install system packages
    echo "Installing system packages..."
    install_packages "${SYSTEM_PACKAGES[@]}"

    # Install development packages
    echo "Installing development packages..."
    install_packages "${DEV_PACKAGES[@]}"
    install_packages "${DEB_DEV_PACKAGES[@]}"

    if [ "$dev_only" = true ]; then
        echo "Development-only mode enabled. Skipping additional packages."
    else
        echo "Installing desktop packages..."
        install_packages "${DESKTOP_PACKAGES[@]}"
        install_desktop_stack

        xdg-user-dirs-update

        # install additional packages
        install_packages "${ADDITIONAL_PACKAGES[@]}"
        install_packages "${DEB_ADDITIONAL_PACKAGES[@]}"
    fi
}

