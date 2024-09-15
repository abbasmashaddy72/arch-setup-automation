#!/bin/bash

# Create logs directory in home if it doesn't exist
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/zshrc_update.log"
mkdir -p "$LOGDIR"

ZSHRC="$HOME/.zshrc"

# Backup the existing .zshrc file if it exists
if [ -f "$ZSHRC" ]; then
    cp "$ZSHRC" "$ZSHRC.backup"
    echo "Backup of .zshrc created at $ZSHRC.backup" | tee -a "$LOGFILE"
else
    echo "No existing .zshrc file found, proceeding without backup." | tee -a "$LOGFILE"
fi

# Check if the custom aliases and functions already exist
if ! grep -q 'alias clean-npm=' "$ZSHRC"; then
    # Add custom functions and shortcuts to .zshrc
    echo "Updating .zshrc with custom shortcuts and functions..." | tee -a "$LOGFILE"

    cat <<EOL >>"$ZSHRC"

# Custom paths and functions for development
export PATH="\$HOME/.config/composer/vendor/bin:\$PATH"

# Function to clean and reinstall npm packages
alias clean-npm='rm -rf node_modules package-lock.json && npm install'

# Function to clean and reinstall composer packages
alias clean-composer='rm -rf vendor composer.lock && composer install'

# Function for php-cs-fixer
php-cs-fixer() {
    if [ -d vendor ]; then
        ./vendor/bin/php-cs-fixer "\$@"
    else
        echo "vendor directory not found"
    fi
}

# Function for pint
pint() {
    if [ -d vendor ]; then
        ./vendor/bin/pint "\$@"
    else
        echo "vendor directory not found"
    fi
}

# Function for artisan
artisan() {
    if [ -f artisan ]; then
        php artisan "\$@"
    else
        echo "artisan file not found"
    fi
}

# Function for sail
sail() {
    if [ -d vendor ]; then
        ./vendor/bin/sail "\$@"
    else
        echo "vendor directory not found"
    fi
}

EOL

    echo ".zshrc updated successfully with custom functions and aliases." | tee -a "$LOGFILE"
else
    echo "Custom functions and aliases already exist in .zshrc, skipping update." | tee -a "$LOGFILE"
fi
