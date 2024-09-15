#!/bin/bash

# Create logs directory in home if it doesn't exist
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/run_all_setup.log"
mkdir -p "$LOGDIR"

echo "Starting full system setup..." | tee -a "$LOGFILE"

# Run system setup
echo "Running system setup..." | tee -a "$LOGFILE"
if ! ./system_setup.sh; then
    echo "[ERROR] System setup failed." | tee -a "$LOGFILE"
    exit 1
fi

# Run PHP, Valet, and Composer setup
echo "Running PHP, Valet, and Composer setup..." | tee -a "$LOGFILE"
if ! ./php_valet_composer_setup.sh; then
    echo "[ERROR] PHP, Valet, and Composer setup failed." | tee -a "$LOGFILE"
    exit 1
fi

# Run package installation
echo "Running package installation..." | tee -a "$LOGFILE"
if ! ./install_packages.sh; then
    echo "[ERROR] Package installation failed." | tee -a "$LOGFILE"
    exit 1
fi

# Run MariaDB setup
echo "Running MariaDB setup..." | tee -a "$LOGFILE"
if ! ./mariadb_setup.sh; then
    echo "[ERROR] MariaDB setup failed." | tee -a "$LOGFILE"
    exit 1
fi

# Run Git configuration
echo "Running Git configuration..." | tee -a "$LOGFILE"
if ! ./git_setup.sh; then
    echo "[ERROR] Git configuration failed." | tee -a "$LOGFILE"
    exit 1
fi

# Run udev rules setup
echo "Running udev rules setup..." | tee -a "$LOGFILE"
if ! ./udev_rules_setup.sh; then
    echo "[ERROR] Udev rules setup failed." | tee -a "$LOGFILE"
    exit 1
fi

# Run zsh configuration
echo "Running zsh configuration..." | tee -a "$LOGFILE"
if ! ./zshrc_config.sh; then
    echo "[ERROR] Zsh configuration failed." | tee -a "$LOGFILE"
    exit 1
fi

echo "Full system setup completed successfully!" | tee -a "$LOGFILE"
