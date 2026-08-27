# Dotfiles

Arch Linux dotfiles managed with GNU Stow. The install script sets up system packages, development tools, and desktop configs for a Hyprland-based workflow.

## Quick Start

```bash
git clone https://github.com/Jojojojodr/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

If you only want the development tools and shell/editor setup, use:

```bash
./install.sh --dev-only
```

## What It Does

- Updates the system with `pacman`
- Installs packages from `packages.conf`
- Installs `yay` if it is missing
- Sets up `zsh` when you choose to enable it
- Symlinks dotfiles into `~/.config` and your home directory with Stow

## Included Configs

- `git`
- `nvim`
- `tmux`
- `zsh`
- `hypr`
- `wayle`
- `rofi`
- `ghostty`

## Notes

- Run the script from the repository root so the relative paths resolve correctly.
- Reboot after setup to ensure shell, group, and desktop changes take effect.
- Wallpapers can be stored in `~/Pictures/wallpapers/`.