#!/bin/bash

# Set up some basic values and help functions
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
CYAN="\e[0;36m"
RESET="\e[0m"
CONFIG_DIR="$HOME/.config"
FONT_DIR="$HOME/.local/share/fonts"

die() { echo -e "${RED}$*${RESET}" >&2; exit 1; }
msg() { echo -e "${CYAN}$*${RESET}"; }

help() {
    echo "Usage: $0 [-h] [-d DISTRO]"
    echo "Options:"
    echo "  -h        Display this help message"
    echo "  -d        Provide the distribution name"
    echo "  DISTRO    fedora or arch"
    exit 0
}

while getopts "hd:" option; do
    case "$option" in
        h)
            help
            ;;
        d)
            DISTRO="${OPTARG}"
            ;;
        ?)
            die
            ;;
    esac
done

if [[ ! -v DISTRO ]]; then
    die "No distro provided"
fi

read -p "Install Sway? (y/n): " -n 1 confirm
echo

if [[ $confirm != "y" && $confirm != "Y" ]]; then
    exit 1
fi

ESSENTIALS=(
    "xdg-user-dirs"
    "xdg-desktop-portal-wlr"
)

DISPLAY_PKGS=(
    "gdm"
)

SWAY_CORE=(
    "sway"
    "swaybg"
    "swayidle"
    "swaylock"
    "swayimg"
    # "swaync"
    "waybar"
)

SWAY_PKGS=(
    "rofi"
    "pavucontrol"
    "grim"
    "slurp"
    "brightnessctl"
    "playerctl"
    "nautilus"
    "papers"
    "loupe"
)

GENERAL_PKGS=(
    "foot"
    "wl-clipboard"
    "firefox"
)

msg "Installing packages..."
if [[ "$DISTRO" == "fedora" ]]; then
    FEDORA_PKGS=(
    )
    sudo dnf upgrade -y
    sudo dnf instlal -y "${ESSENTIALS[@]}"
    sudo dnf install -y "${DISPLAY_PKGS[@]}"
    sudo dnf install -y "${SWAY_CORE[@]}"
    sudo dnf install -y "${SWAY_PKGS[@]}"
    sudo dnf install -y "${GENERAL_PKGS[@]}"
    sudo dnf install -y "${FEDORA_PKGS[@]}"
elif [[ "$DISTRO" == "arch" ]]; then
    ARCH_PKGS=(
    )
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm "${ESSENTIALS[@]}"
    sudo pacman -S --noconfirm "${DISPLAY_PKGS[@]}"
    sudo pacman -S --noconfirm "${SWAY_CORE[@]}"
    sudo pacman -S --noconfirm "${SWAY_PKGS[@]}"
    sudo pacman -S --noconfirm "${GENERAL_PKGS[@]}"
    sudo pacman -S --noconfirm "${ARCH_PKGS[@]}"
fi

# Setup folders and copy the config files
msg "Creating user directories..."
LC_ALL=C.UTF-8 xdg-user-dirs-update --force

# systemctl --user enable xdg-user-dirs.service
msg "Enabling gdm service..."
sudo systemctl enable gdm.service
msg "Enabling graphical login..."
sudo systemctl set-default graphical.target

msg "Copying config files..."
cp -r ./config/. "${CONFIG_DIR}/"

# Install fonts
mkdir -p $FONT_DIR
msg "Downloading JetBrainsMono Fonts..."
wget -q https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip
msg "Downloading JetBrainsMono Nerd Fonts..."
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
msg "Downloading Font-Awesome Fonts..."
wget -q https://github.com/FortAwesome/Font-Awesome/releases/download/7.1.0/fontawesome-free-7.1.0-desktop.zip
msg "Installing JetBrainsMono Fonts..."
unzip JetBrainsMono-2.304.zip -d "$FONT_DIR/jetbrains-mono"
msg "Installing JetBrainsMono Nerd Fonts..."
unzip JetBrainsMono.zip -d "$FONT_DIR/jetbrains-mono-nerd-font"
msg "Installing Font-Awesome Fonts..."
unzip fontawesome-free-7.1.0-desktop.zip -d "$FONT_DIR/fontawesome-free-7"
rm JetBrainsMono-2.304.zip
rm JetBrainsMono.zip
rm fontawesome-free-7.1.0-desktop.zip
