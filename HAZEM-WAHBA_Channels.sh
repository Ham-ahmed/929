#!/bin/sh

# color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Variables
channel="HAZEM-WAHBA"
version="motor"
backup_url="https://raw.githubusercontent.com/Ham-ahmed/929/refs/heads/main/channels_backup_OpenBlackhole_20250913_HAZEMWAHBA-CIEFP.tar.gz"
temp_file="/var/volatile/tmp/${channel}-${version}.tar.gz"

# Function for color printing
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to verify the success of the operation
check_success() {
    if [ $? -eq 0 ]; then
        print_message "$GREEN" "✓ تم بنجاح"
    else
        print_message "$RED" "✗ فشل العملية"
        exit 1
    fi
}

clear
print_message "$CYAN" "================================================"
print_message "$WHITE" "    Install channels $channel - $version"
print_message "$CYAN" "================================================"
echo

# Download channels
print_message "$YELLOW" "> Loading channels $channel $version ..."
sleep 2

wget -O "$temp_file" "$backup_url"
check_success
echo

# Clean old files
print_message "$YELLOW" "> Old ducts are being cleaned ..."
rm -rf /etc/enigma2/lamedb
rm -rf /etc/enigma2/*list
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/tuxbox/*.xml
check_success
echo

# Install new channels
print_message "$YELLOW" "> New channels are being installed ..."
sleep 2

cd /tmp
set -e
tar -xvf "$temp_file" -C /
set +e
check_success
echo

# Clean the temporary file
print_message "$YELLOW" "> Cleaning in progress ..."
rm -f "$temp_file"
check_success
echo

# Reload services
print_message "$YELLOW" "> Services are being reloaded ..."
wget -qO - http://127.0.0.1/web/servicelistreload?mode=0 > /dev/null 2>&1
sleep 2
check_success
echo

print_message "$GREEN" "================================================"
print_message "$GREEN" "  The channels have been installed successfully!"
print_message "$GREEN" "      ... Interface is being rebooted ...       "
print_message "$GREEN" "           ... MagicPanelPro v6.2 ...           "
print_message "$GREEN" "        ... Uploaded by Hamdy Ahmed ...         "
print_message "$GREEN" "================================================"

sleep 3
init 3

exit 0