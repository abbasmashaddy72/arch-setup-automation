#!/bin/bash

# Create logs directory in home if it doesn't exist
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/mariadb_setup.log"
mkdir -p "$LOGDIR"

echo "Starting MariaDB setup..." | tee -a "$LOGFILE"

# Error handling: Exit on error
set -e

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a "$LOGFILE"
}

# Install MariaDB
echo "Installing MariaDB..." | tee -a "$LOGFILE"
if ! sudo pacman -S --needed --noconfirm mariadb; then
    log_error "Failed to install MariaDB."
fi

# Initialize MariaDB
echo "Initializing MariaDB..." | tee -a "$LOGFILE"
if ! sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql; then
    log_error "Failed to initialize MariaDB."
fi

# Enable and start MariaDB service
echo "Enabling and starting MariaDB service..." | tee -a "$LOGFILE"
if ! sudo systemctl enable --now mariadb; then
    log_error "Failed to enable MariaDB service."
fi

# Check MariaDB service status
echo "Checking MariaDB service status..." | tee -a "$LOGFILE"
if ! sudo systemctl is-active --quiet mariadb; then
    log_error "MariaDB service is not running as expected."
fi

# Secure MariaDB installation
echo "Securing MariaDB installation..." | tee -a "$LOGFILE"
if ! sudo mariadb-secure-installation; then
    log_error "Failed to secure MariaDB installation."
fi

echo "MariaDB setup completed successfully!" | tee -a "$LOGFILE"
