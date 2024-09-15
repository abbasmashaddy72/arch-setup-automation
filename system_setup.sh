#!/bin/bash

# Create logs directory in home if it doesn't exist
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/system_setup.log"
mkdir -p "$LOGDIR"

echo "Starting system setup..." | tee -a "$LOGFILE"

# Error handling: Exit on error
set -e

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a "$LOGFILE"
}

# Update pacman mirrors
echo "Updating pacman mirrors..." | tee -a "$LOGFILE"
if ! sudo pacman-mirrors --fasttrack; then
    log_error "Failed to update mirrors"
fi

# Check fstrim.timer status
echo "Checking fstrim.timer status..." | tee -a "$LOGFILE"
if ! sudo systemctl status fstrim.timer; then
    log_error "Failed to check fstrim.timer status"
fi

# Check current swappiness value
echo "Current swappiness value:" | tee -a "$LOGFILE"
cat /proc/sys/vm/swappiness | tee -a "$LOGFILE"

# Set swappiness to 10
echo "Setting swappiness to 10..." | tee -a "$LOGFILE"
if ! echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/100-manjaro.conf >/dev/null; then
    log_error "Failed to set swappiness"
fi

# Install UFW and GUFW
echo "Installing UFW and GUFW..." | tee -a "$LOGFILE"
if ! sudo pacman -S --noconfirm ufw gufw; then
    log_error "Failed to install UFW and GUFW"
fi

# Enable UFW
echo "Enabling UFW..." | tee -a "$LOGFILE"
if ! sudo ufw enable; then
    log_error "Failed to enable UFW"
fi

if ! sudo systemctl enable ufw; then
    log_error "Failed to enable UFW service"
fi

# Check UFW status
if ! sudo ufw status; then
    log_error "Failed to check UFW status"
fi

# Update GRUB configuration (this step requires manual input with nano)
echo "Updating GRUB configuration..." | tee -a "$LOGFILE"
sudo nano /etc/default/grub
if ! sudo update-grub; then
    log_error "Failed to update GRUB"
fi

# Install language tools
echo "Installing language tools..." | tee -a "$LOGFILE"
if ! sudo pacman -S --noconfirm aspell-en libmythes mythes-en languagetool; then
    log_error "Failed to install language tools"
fi

echo "System setup completed successfully!" | tee -a "$LOGFILE"
