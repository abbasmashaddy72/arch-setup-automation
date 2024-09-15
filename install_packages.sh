#!/bin/bash

# Create logs directory in home if it doesn't exist
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/install_packages.log"
mkdir -p "$LOGDIR"

echo "Starting package installation..." | tee -a "$LOGFILE"

# Error handling: Exit on error
set -e

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a "$LOGFILE"
    exit 1
}

# Function to check if a package is installed using pacman
is_installed_pacman() {
    pacman -Qi "$1" &>/dev/null
    return $?
}

# Function to check if a package is installed using pamac
is_installed_pamac() {
    pamac list --installed "$1" &>/dev/null
    return $?
}

# Function to install a package using pacman
install_with_pacman() {
    echo "Installing $1 with pacman..." | tee -a "$LOGFILE"
    if ! sudo pacman -S --needed --noconfirm "$1"; then
        log_error "Failed to install $1 with pacman"
    fi
}

# Function to install a package using pamac
install_with_pamac() {
    echo "Installing $1 with pamac..." | tee -a "$LOGFILE"
    if ! pamac install --no-confirm "$1"; then
        log_error "Failed to install $1 with pamac"
    fi
}

# Function to install packages
install_package() {
    local package="$1"
    local manager="$2"

    if [ "$manager" == "pacman" ]; then
        if is_installed_pacman "$package"; then
            echo "$package is already installed (pacman)." | tee -a "$LOGFILE"
        else
            install_with_pacman "$package"
        fi
    elif [ "$manager" == "pamac" ]; then
        if is_installed_pamac "$package"; then
            echo "$package is already installed (pamac)." | tee -a "$LOGFILE"
        else
            install_with_pamac "$package"
        fi
    fi
}

# Pacman packages
pacman_packages=(
    dbeaver
    deluge-gtk
    firefox-developer-edition
    firefox
    handbrake
    keepassxc
    libreoffice-fresh
    meld
    virtualbox
    pycharm-community-edition
    scrcpy
    remmina
    vlc
    timeshift
    android-tools
    mariadb
    tree
    zip
    unzip
    brave-browser
    ventoy
    curl
    cpu-checker
    kvm-ok
    linux-headers
    virtualbox-guest-utils
    libimobiledevice
    ifuse
    usbmuxd
    gvfs-afc
)

# Pamac packages
pamac_packages=(
    android-studio
    anydesk
    docker-desktop
    ferdium-bin
    google-chrome
    visual-studio-code-bin
    winscp
    balena-etcher
    sublime-text-4
    woeusb
)

# Install zed.dev
echo "Installing zed.dev..." | tee -a "$LOGFILE"
if ! curl -fsSL https://zed.dev/install.sh | sh; then
    log_error "Failed to install zed.dev"
fi

echo "Starting pacman package installation..." | tee -a "$LOGFILE"

# Install pacman packages
for package in "${pacman_packages[@]}"; do
    install_package "$package" "pacman"
done

# Check if pamac is installed before installing AUR packages
if command -v pamac &>/dev/null; then
    echo "Starting pamac package installation..." | tee -a "$LOGFILE"

    # Install pamac packages
    for package in "${pamac_packages[@]}"; do
        install_package "$package" "pamac"
    done
else
    log_error "pamac not found, cannot install AUR packages."
fi

echo "Package installation completed!" | tee -a "$LOGFILE"
