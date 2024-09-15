# Manjaro System Setup Automation

This project contains a series of bash scripts to automate the installation and configuration of packages, system settings, and services on Manjaro Linux. It simplifies the process of setting up your system for development and managing all necessary packages and services efficiently.

## Overview

The project includes seven main scripts:

1. **System Setup Script (`system_setup.sh`)**  
   This script handles system configuration, enabling UFW firewall, updating pacman mirrors, setting swappiness, and updating GRUB.

2. **PHP, Valet, and Composer Setup Script (`php_valet_composer_setup.sh`)**  
   Installs PHP, Composer, and Valet Linux. It also installs necessary PHP packages and configures the environment for web development.

3. **Package Installation Script (`install_packages.sh`)**  
   Installs a list of essential packages using both `pacman` and `pamac` (for AUR packages). It checks for installed packages and installs missing ones.

4. **MariaDB Setup Script (`mariadb_setup.sh`)**  
   Sets up MariaDB, initializes the database, enables the service, and secures the installation.

5. **Git Configuration Script (`git_setup.sh`)**  
   Configures Git credentials and installs Git Credential Manager for seamless access to repositories.

6. **Udev Rules Setup Script (`udev_rules_setup.sh`)**  
   Sets up custom udev rules for iPhone and Android devices by adding the appropriate `idVendor` and `idProduct` values for managing USB connections.

7. **Zsh Configuration Script (`zshrc_config.sh`)**  
   Adds custom aliases and functions to `.zshrc` for development efficiency, including npm, composer, and Laravel-specific shortcuts.

8. **Run All Setup Script (`run_all_setup.sh`)**  
   Runs all the above scripts in the correct order for a complete system setup in one go.

---

## Setup Instructions

### Step 1: Make Scripts Executable

Before running the scripts, make them executable:

```bash
chmod +x system_setup.sh php_valet_composer_setup.sh install_packages.sh mariadb_setup.sh git_setup.sh udev_rules_setup.sh zshrc_config.sh run_all_setup.sh
```

### Step 2: Run the Scripts

You can either run the scripts individually or use the **Run All Setup Script** to run them all at once.

#### Option 1: Run Scripts Individually

1. **System Setup**:

   ```bash
   ./system_setup.sh
   ```

2. **PHP, Valet, and Composer Setup**:

   ```bash
   ./php_valet_composer_setup.sh
   ```

3. **Package Installation**:

   ```bash
   ./install_packages.sh
   ```

4. **MariaDB Setup**:

   ```bash
   ./mariadb_setup.sh
   ```

5. **Git Configuration**:

   ```bash
   ./git_setup.sh
   ```

6. **Udev Rules Setup**:

   ```bash
   ./udev_rules_setup.sh
   ```

7. **Zsh Configuration**:

   ```bash
   ./zshrc_config.sh
   ```

#### Option 2: Run All Setup at Once

Use the `run_all_setup.sh` script to run all the scripts sequentially:

```bash
./run_all_setup.sh
```

---

## Package List

### Packages installed via `pacman`

- dbeaver
- deluge-gtk
- firefox-developer-edition
- firefox
- handbrake
- keepassxc
- libreoffice-fresh
- meld
- virtualbox
- pycharm-community-edition
- scrcpy
- remmina
- vlc
- timeshift
- android-tools
- mariadb
- tree
- zip
- unzip
- brave-browser
- ventoy

### Packages installed via `pamac` (AUR)

- android-studio
- anydesk
- docker-desktop
- ferdium-bin
- google-chrome
- visual-studio-code-bin
- winscp
- balena-etcher
- sublime-text-4
- woeusb

---

## Additional Configurations

- **UFW**: Enables the Uncomplicated Firewall (UFW) and starts it on boot.
- **Swappiness**: Sets system swappiness to `10`.
- **PHP, Valet, and Composer**: Installs PHP, Composer, and Valet for web development.
- **MariaDB**: Installs, enables, and secures MariaDB.
- **Udev Rules**: Adds custom udev rules for iPhone and Android devices.
- **Zsh Customizations**: Adds custom aliases and shortcuts for npm, composer, and Laravel development in `.zshrc`.

---

## Contributing

Feel free to submit issues or pull requests if you'd like to contribute!

---

Maintained by [Syed Kounain Abbas Rizvi](https://github.com/abbasmashaddy72).
