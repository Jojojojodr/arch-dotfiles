#!/usr/bin/env bash

install_zsh() {
    # Set zsh as the default shell
    zsh_path=$(grep zsh$ /etc/shells | head -n 1)
    if [ "$SHELL" != "$zsh_path" ]; then
        echo "Changing default shell to zsh..." 
        chsh -s "$zsh_path" "$(whoami)"
    else
        echo "zsh is already the default shell."
    fi

    # Install oh-my-zsh
    if [ ! -d ~/.oh-my-zsh ]; then
        echo "Installing oh-my-zsh..."
        CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo "oh-my-zsh installed successfully."
    else
        echo "oh-my-zsh is already installed."
    fi

    # Install zsh plugins
    if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        echo "zsh-autosuggestions installed successfully."
    else
        echo "zsh-autosuggestions is already installed."
    fi
    if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        echo "zsh-syntax-highlighting installed successfully."
    else
        echo "zsh-syntax-highlighting is already installed."
    fi

    # Install powerlevel10k theme
    if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
        echo "Installing powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        echo "Powerlevel10k theme installed successfully."
    else
        echo "powerlevel10k theme is already installed."
    fi
}