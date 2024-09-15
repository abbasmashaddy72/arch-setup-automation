#!/bin/bash

# Create logs directory in home if it doesn't exist
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/php_valet_composer_setup.log"
mkdir -p "$LOGDIR"

echo "Starting PHP, Valet, and Composer setup..." | tee -a "$LOGFILE"

# Error handling: Exit on error
set -e

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a "$LOGFILE"
    exit 1
}

# List of PHP packages to install
php_packages=(
    php-apcu
    php-intl
    php-mbstring
    php-openssl
    php-pdo
    php-tokenizer
    php-pdo-mysql
    php-redis
    php-json
    php-xml
    php-zip
    php-xdebug
    php-iconv
    php-sqlite
    php-gd
)

# Install PHP and related packages
echo "Installing PHP and related packages..." | tee -a "$LOGFILE"
if ! sudo pacman -S --noconfirm "${php_packages[@]}"; then
    log_error "Failed to install PHP packages"
fi

# Install Node.js and NPM
echo "Installing Node.js and NPM..." | tee -a "$LOGFILE"
if ! sudo pacman -S --noconfirm nodejs npm; then
    log_error "Failed to install Node.js and NPM"
fi

# Install Composer
echo "Installing Composer..." | tee -a "$LOGFILE"
if ! php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; then
    log_error "Failed to download Composer installer"
fi

EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    log_error "Invalid Composer installer checksum"
    rm composer-setup.php
fi

if ! php composer-setup.php --quiet; then
    log_error "Failed to install Composer"
    rm composer-setup.php
fi

rm composer-setup.php
if ! sudo mv composer.phar /usr/local/bin/composer; then
    log_error "Failed to move Composer to /usr/local/bin"
fi

# Add Composer's global vendor bin to the PATH in .zshrc
echo "Adding Composer vendor bin to the PATH in .zshrc..." | tee -a "$LOGFILE"
ZSHRC="$HOME/.zshrc"
if ! grep -q 'export PATH="\$HOME/.config/composer/vendor/bin:\$PATH"' "$ZSHRC"; then
    echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >>"$ZSHRC"
    echo "Composer vendor bin path added to .zshrc." | tee -a "$LOGFILE"
else
    echo "Composer vendor bin path already exists in .zshrc." | tee -a "$LOGFILE"
fi

# Suggest terminal restart instead of reloading .zshrc
echo "Please restart your terminal to apply changes to PATH." | tee -a "$LOGFILE"

# Verify Composer installation
echo "Verifying Composer installation..." | tee -a "$LOGFILE"
if ! composer -v; then
    log_error "Failed to verify Composer installation"
fi

# Install Valet Linux
echo "Installing Valet Linux..." | tee -a "$LOGFILE"
if ! composer global require cpriego/valet-linux; then
    log_error "Failed to install Valet Linux"
fi

# List of dependencies for Valet Linux
valet_dependencies=(
    nss
    jq
    xsel
    networkmanager
)

# Install necessary dependencies for Valet Linux
echo "Installing dependencies for Valet Linux..." | tee -a "$LOGFILE"
if ! sudo pacman -S --noconfirm "${valet_dependencies[@]}"; then
    log_error "Failed to install Valet Linux dependencies"
fi

# Check php-fpm status
echo "Checking php-fpm status..." | tee -a "$LOGFILE"
if ! sudo systemctl status php-fpm.service; then
    log_error "php-fpm service is not running as expected"
fi

echo "PHP, Valet, and Composer setup completed successfully!" | tee -a "$LOGFILE"
