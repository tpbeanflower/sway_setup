#!/bin/bash

# Set up some basic values and help functions
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
CYAN="\e[0;36m"
RESET="\e[0m"
CONFIG_DIR="$HOME/.config"

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

DISPLAY_PKGS=(
    "gdm"
    "sddm"
)

SWAY_CORE=(
    "sway"
    "swaybg"
    "swayidle"
    "swaylock"
    "swayimg"
    "swaync"
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

if [[ "$DISTRO" == "fedora" ]]; then
    FEDORA_PKGS=(
        "NetworkManager"
    )
    sudo dnf upgrade -y
    sudo dnf install -y "${DISPLAY_PKGS[@]}"
    sudo dnf install -y "${SWAY_CORE[@]}"
    sudo dnf install -y "${SWAY_PKGS[@]}"
    sudo dnf install -y "${GENERAL_PKGS[@]}"
    sudo dnf install -y "${FEDORA_PKGS[@]}"
elif [[ "$DISTRO" == "arch" ]]; then
    ARCH_PKGS=(
        "networkmanager"
        "ttf-jetbrains-mono-nerd"
    )
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm "${DISPLAY_PKGS[@]}"
    sudo pacman -S --noconfirm "${SWAY_CORE[@]}"
    sudo pacman -S --noconfirm "${SWAY_PKGS[@]}"
    sudo pacman -S --noconfirm "${GENERAL_PKGS[@]}"
    sudo pacman -S --noconfirm "${ARCH_PKGS[@]}"
fi

sudo systemctl enable NetworkManager.service
# sudo systemctl enable gdm.service
sudo systemctl enable sddm.service

# Setup folders and copy the config files
xdg-user-dirs-update
# mkdir -p "${CONFIG_DIR}/sway"
# mkdir -p "${CONFIG_DIR}/waybar"
# mkdir -p "${CONFIG_DIR}/rofi"
# mkdir -p "${CONFIG_DIR}/foot"

cp -r ./config/ "${CONFIG_DIR}/"
