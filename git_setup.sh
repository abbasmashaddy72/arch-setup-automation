#!/bin/bash

# Create logs directory in home if it doesn't exist
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/git_setup.log"
mkdir -p "$LOGDIR"

echo "Starting Git setup..." | tee -a "$LOGFILE"

# Error handling: Exit on error
set -e

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a "$LOGFILE"
    exit 1
}

# Prompt user for Git username and email with validation
read -p "Enter your Git username: " git_username
if [[ -z "$git_username" ]]; then
    log_error "Git username cannot be empty."
fi

read -p "Enter your Git email: " git_email
if [[ -z "$git_email" ]]; then
    log_error "Git email cannot be empty."
fi

# Install Git Credential Manager
echo "Installing Git Credential Manager..." | tee -a "$LOGFILE"
if ! sudo pacman -S --noconfirm git-credential-manager; then
    log_error "Failed to install Git Credential Manager."
fi

# Configure Git credential cache
echo "Configuring Git credentials..." | tee -a "$LOGFILE"
if ! git config --global credential.helper 'cache --timeout=3600'; then
    log_error "Failed to configure Git credential helper."
fi

# Set Git username
echo "Setting Git username to $git_username..." | tee -a "$LOGFILE"
if ! git config --global user.name "$git_username"; then
    log_error "Failed to set Git username."
fi

# Set Git email
echo "Setting Git email to $git_email..." | tee -a "$LOGFILE"
if ! git config --global user.email "$git_email"; then
    log_error "Failed to set Git email."
fi

echo "Git setup completed successfully!" | tee -a "$LOGFILE"
