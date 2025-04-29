#!/bin/bash
set -e  # Exit immediately if a command fails

### https://github.com/JaKooLit/JaKooLit
### https://github.com/AXWTV

clear

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

printf "\n%.0s" {1..3}  
echo " █████╗ ██╗  ██╗██╗    ██╗████████╗██╗   ██╗"
echo "██╔══██╗╚██╗██╔╝██║    ██║╚══██╔══╝██║   ██║"
echo "███████║ ╚███╔╝ ██║ █╗ ██║   ██║   ██║   ██║"
echo "██╔══██║ ██╔██╗ ██║███╗██║   ██║   ╚██╗ ██╔╝"
echo "██║  ██║██╔╝ ██╗╚███╔███╔╝   ██║    ╚████╔╝ "
echo "╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝    ╚═╝     ╚═══╝  "
echo "                                            "
printf "\n%.0s" {1..2} 

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Create Directory for Copy Logs
mkdir -p Copy-Logs

# Set the name of the log file to include the current date and time (with seconds)
LOG="Copy-Logs/install-$(date +%d-%H%M%S)_dotfiles.log"

# update home folders
xdg-user-dirs-update 2>&1 | tee -a "$LOG" || true

# uncommenting WLR_NO_HARDWARE_CURSORS if nvidia is detected
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
  sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  sed -i '/env = LIBVA_DRIVER_NAME,nvidia/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  sed -i '/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^#//' config/hypr/UserConfigs/ENVariables.conf
fi

# uncommenting WLR_RENDERER_ALLOW_SOFTWARE,1 if running in a VM is detected
if hostnamectl | grep -q 'Chassis: vm'; then
  echo "This script is running in a virtual machine."
  sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  sed -i '/env = WLR_RENDERER_ALLOW_SOFTWARE,1/s/^#//' config/hypr/UserConfigs/ENVariables.conf
  sed -i '/monitor = Virtual-1, 1920x1080@60,auto,1/s/^#//' config/hypr/UserConfigs/Monitors.conf
fi

# Function to detect keyboard layout using localectl or setxkbmap
detect_layout() {
  if command -v localectl >/dev/null 2>&1; then
    layout=$(localectl status --no-pager | awk '/X11 Layout/ {print $3}')
    echo "${layout:-unknown}"
  elif command -v setxkbmap >/dev/null 2>&1; then
    layout=$(setxkbmap -query | awk '/layout/ {print $2}')
    echo "${layout:-unknown}"
  else
    echo "unknown"
  fi
}

layout=$(detect_layout)

printf "${NOTE} Detecting keyboard layout to prepare necessary changes in hyprland.conf before copying\n\n"

while true; do
    read -p "$ORANGE Detected current keyboard layout is: $layout. Is this correct? [y/n] " confirm
    case $confirm in
        [yY])
            awk -v layout="$layout" '/kb_layout/ {$0 = "  kb_layout=" layout} 1' config/hypr/UserConfigs/UserSettings.conf > temp.conf
            mv temp.conf config/hypr/UserConfigs/UserSettings.conf
            echo "${NOTE} kb_layout $layout configured in settings." | tee -a "$LOG"
            break ;;
        [nN])
            printf "\n%.0s" {1..2}
            echo "$(tput bold)$(tput setaf 3)ATTENTION!!!! VERY IMPORTANT!!!! $(tput sgr0)" 
            echo "$(tput bold)$(tput setaf 7)Setting a wrong value here will result in Hyprland not starting $(tput sgr0)"
            echo "$(tput bold)$(tput setaf 7)If you are not sure, keep it in us layout. You can change later on! $(tput sgr0)"
            echo "$(tput bold)$(tput setaf 7)You can also set more than 2 layouts! Example: us,kr,es $(tput sgr0)"
            printf "\n%.0s" {1..2}
            read -p "${CAT} - Please enter the correct keyboard layout: " new_layout
            awk -v new_layout="$new_layout" '/kb_layout/ {$0 = "  kb_layout=" new_layout} 1' config/hypr/UserConfigs/UserSettings.conf > temp.conf
            mv temp.conf config/hypr/UserConfigs/UserSettings.conf
            echo "${NOTE} kb_layout $new_layout configured in settings." | tee -a "$LOG"
            break ;;
        *)
            echo "Please enter either 'y' or 'n'." ;;
    esac
done

printf "\n%.0s" {1..2}

### Copy Config Files ###
printf "${NOTE} - Copying dotfiles\n"

get_backup_dirname() {
  local timestamp
  timestamp=$(date +"%m%d_%H%M%S")
  echo "back-up_${timestamp}"
}

for DIR in alacritty btop cava hypr kitty Kvantum qt5ct qt6ct rofi swappy swaync swaylock tmux wal waybar wlogout; do 
  DIRPATH="$HOME/.config/$DIR"
  if [ -d "$DIRPATH" ]; then 
    echo -e "${NOTE} - Config for $DIR found, attempting to back up."
    BACKUP_DIR=$(get_backup_dirname)
    mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR" | tee -a "$LOG"
    echo -e "${NOTE} - Backed up $DIR to $DIRPATH-backup-$BACKUP_DIR."
  fi
done

# Clear Neovim caches and config
if [ -d "$HOME/.cache/nvim" ]; then
  rm -rf "$HOME/.cache/nvim"
  echo "Nvim cache has been cleared."
fi

if [ -d "$HOME/.local/share/nvim" ]; then
  rm -rf "$HOME/.local/share/nvim"
  echo "Nvim local share directory has been cleared."
fi

if [ -d "$HOME/.config/nvim" ]; then
  rm -rf "$HOME/.config/nvim"
  echo "Nvim config directory has been cleared."
fi

git clone https://github.com/NvChad/NvChad "$HOME/.config/nvim" --depth 1

# Backup wallpapers
DIRPATH="$HOME/Pictures/wallpapers"
if [ -d "$DIRPATH" ]; then 
  echo -e "${NOTE} - Wallpapers found, attempting to back up."
  BACKUP_DIR=$(get_backup_dirname)
  mv "$DIRPATH" "$DIRPATH-backup-$BACKUP_DIR" | tee -a "$LOG"
  echo -e "${NOTE} - Backed up wallpapers to $DIRPATH-backup-$BACKUP_DIR."
fi

printf "\n%.0s" {1..2}

# Copying config files
mkdir -p "$HOME/.config"
cp -r config/* "$HOME/.config/" && { echo "${OK} ✅ Config copy completed!"; } || { echo "${ERROR} ❌ Failed to copy config files."; exit 1; } | tee -a "$LOG"

# Copying wallpapers
mkdir -p "$HOME/Pictures/wallpapers"
cp -r wallpapers "$HOME/Pictures/" && { echo "${OK} ✅ Wallpaper copy completed!"; } || { echo "${ERROR} ❌ Failed to copy wallpapers."; exit 1; } | tee -a "$LOG"

# Make scripts executable
chmod +x "$HOME/.config/hypr/scripts/"* | tee -a "$LOG"
chmod +x "$HOME/.config/hypr/initial-boot.sh" | tee -a "$LOG"

printf "\n%.0s" {1..3}
echo "$(tput setaf 6) By default only a few wallpapers are copied...$(tput sgr0)"
printf "\n%.0s" {1..2}

while true; do
    read -rp "${CAT} Would you like to download additional wallpapers? (y/n) " WALL
    case $WALL in
        [Yy])
            echo "${NOTE} Downloading additional wallpapers..."
            if git clone "https://github.com/AXWTV/Wallpaper-Area.git"; then
                echo "${NOTE} Wallpapers downloaded successfully." | tee -a "$LOG"
                if cp -R Wallpaper-Area/wallpapers/* "$HOME/Pictures/wallpapers/" >> "$LOG" 2>&1; then
                    echo "${NOTE} Wallpapers copied successfully." | tee -a "$LOG"
                    rm -rf Wallpaper-Area
                    break
                else
                    echo "${ERROR} Copying wallpapers failed" | tee -a "$LOG"
                fi
            else
                echo "${ERROR} Downloading additional wallpapers failed" | tee -a "$LOG"
            fi
            ;;
        [Nn])
            echo "You chose not to download additional wallpapers." | tee -a "$LOG"
            break
            ;;
        *)
            echo "Please enter 'y' or 'n' to proceed."
            ;;
    esac
done

printf "\n%.0s" {1..2}
echo -e "\n${OK} ✅ Copy Completed!\n"
echo -e "${ORANGE} ⚠️  ATTENTION!!!!"
echo -e "${ORANGE} You NEED to logout and re-login or reboot to avoid issues\n"
