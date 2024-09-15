#!/bin/bash

# Create logs directory in home if it doesn't exist
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/udev_rules_setup.log"
mkdir -p "$LOGDIR"

echo "Starting udev rules setup for iPhone and Android..." | tee -a "$LOGFILE"

# Error handling: Exit on error
set -e

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a "$LOGFILE"
    exit 1
}

# Prompt for iPhone and Android idVendor and idProduct
read -p "Enter iPhone idVendor (default: 05ac): " iphone_vendor
read -p "Enter iPhone idProduct (default: *): " iphone_product
read -p "Enter Android idVendor (default: 1004): " android_vendor
read -p "Enter Android idProduct (default: 633e): " android_product

# Use default values if none provided
iphone_vendor=${iphone_vendor:-05ac}
iphone_product=${iphone_product:-*}
android_vendor=${android_vendor:-1004}
android_product=${android_product:-633e}

# Create iPhone udev rule
echo "Creating iPhone udev rule with idVendor=$iphone_vendor and idProduct=$iphone_product..." | tee -a "$LOGFILE"
if ! sudo bash -c "echo 'ACTION==\"add|change\", SUBSYSTEM==\"usb\", ATTR{idVendor}==\"$iphone_vendor\", ATTR{idProduct}==\"$iphone_product\", ENV{ID_MM_DEVICE_IGNORE}=\"1\"' > /etc/udev/rules.d/99-iphone-ignore-modemmanager.rules"; then
    log_error "Failed to create iPhone udev rule."
fi

# Create Android udev rule
echo "Creating Android udev rule with idVendor=$android_vendor and idProduct=$android_product..." | tee -a "$LOGFILE"
if ! sudo bash -c "echo 'ACTION==\"add|change\", SUBSYSTEM==\"usb\", ATTR{idVendor}==\"$android_vendor\", ATTR{idProduct}==\"$android_product\", ENV{ID_MM_DEVICE_IGNORE}=\"1\", ENV{UDISKS_IGNORE}=\"1\", ENV{MTP_IGNORE}=\"1\", ENV{GVFS_IGNORE}=\"1\", ENV{ID_GPHOTO2_IGNORE}=\"1\"' > /etc/udev/rules.d/99-android.rules"; then
    log_error "Failed to create Android udev rule."
fi

# Set permissions for the udev rules
echo "Setting permissions for udev rules..." | tee -a "$LOGFILE"
if ! sudo chmod a+r /etc/udev/rules.d/99-iphone-ignore-modemmanager.rules /etc/udev/rules.d/99-android.rules; then
    log_error "Failed to set permissions for udev rules."
fi

# Reload udev rules
echo "Reloading udev rules..." | tee -a "$LOGFILE"
if ! sudo udevadm control --reload-rules; then
    log_error "Failed to reload udev rules."
fi

# Restart usbmuxd service
echo "Restarting usbmuxd service..." | tee -a "$LOGFILE"
if ! sudo systemctl restart usbmuxd; then
    log_error "Failed to restart usbmuxd service."
fi

echo "iPhone and Android udev rules created and reloaded successfully!" | tee -a "$LOGFILE"
