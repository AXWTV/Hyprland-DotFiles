#!/bin/bash

hyprDir="$HOME/.config/hypr/configs"

menu(){
  printf "1. view Env-variables\n"
  printf "2. view Rules\n"
  printf "3. view Execs (startup)\n"
  printf "4. view KeyBinds\n"
  printf "5. view Monitors\n"
  printf "6. view Laptop-Keybinds\n"
  printf "7. view Hyprland-Settings\n"
}

main() {
    choice=$(menu | rofi -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)
    case $choice in
        1)
            alacritty -e vim "$hyprDir/ENVariables.conf"
            ;;
        2)
            alacritty -e vim "$hyprDir/WindowRules.conf"
            ;;
        3)
            alacritty -e vim "$hyprDir/Execs.conf"
            ;;
        4)
            alacritty -e vim "$hyprDir/Keybinds.conf"
            ;;
        5)
            alacritty -e vim "$hyprDir/Monitors.conf"
            ;;
        6)
            alacritty -e vim "$hyprDir/Laptops.conf"
            ;;
        7)
            alacritty -e vim "$hyprDir/Settings.conf"
            ;;
        *)
            ;;
    esac
}

main
