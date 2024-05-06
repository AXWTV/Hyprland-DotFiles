#!/bin/bash
## /* ---- 💫 https://github.com/AXWTV 💫 ---- */  ##
# For Swaylock

#CONFIG="$HOME/.config/swaylock/config"

#sleep 0.5s; swaylock --config ${CONFIG} & disown

# for Hyprlock
#
CONFIG="$HOME/.config/hypr/hyprlock.conf"

sleep 0.5s; hyprlock --config ${CONFIG} & disown
