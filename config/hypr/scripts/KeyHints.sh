#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Keyhints. Idea got from Garuda Hyprland

# Detect monitor resolution and scale
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# Calculate width and height based on percentages and monitor resolution
width=$((x_mon * hypr_scale / 100))
height=$((y_mon * hypr_scale / 100))

# Set maximum width and height
max_width=1200
max_height=1000

# Set percentage of screen size for dynamic adjustment
percentage_width=70
percentage_height=70

# Calculate dynamic width and height
dynamic_width=$((width * percentage_width / 100))
dynamic_height=$((height * percentage_height / 100))

# Limit width and height to maximum values
dynamic_width=$(($dynamic_width > $max_width ? $max_width : $dynamic_width))
dynamic_height=$(($dynamic_height > $max_height ? $max_height : $dynamic_height))

# Launch yad with calculated width and height
yad --width=$dynamic_width --height=$dynamic_height \
    --center \
    --title="Keybindings" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
"ESC" "close this app" "" "=" "SUPER KEY (Windows Key)" "(SUPER KEY)" \
" enter" "Terminal" "(alacritty)" \
" or  D" "App Launcher" "(AGS)" \
" T" "Open File Manager" "(Nautilus)" \
" Q" "close active window" "(not kill)" \
" Shift Q " "closes a specified window" "(window)" \
" Alt V" "Clipboard Manager" "(cliphist)" \
" R" "Reload Hyprland" "Reloads AGS and Hyprland" \
" Print" "screenshot" "(grim)" \
" Shift Print" "screenshot region" "(grim + slurp)" \
" Shift S" "screenshot region" "(swappy)" \
"ALT Print" "Screenshot active window" "active window only" \
"CTRL ALT P" "power-menu" "(AGS)" \
"CTRL ALT L" "screen lock" "(Hyprlock)" \
"CTRL ALT Del" "Hyprland Exit" "(SAVE YOUR WORK!!!)" \
" F" "Fullscreen" "Toggles to full screen" \
" ALT L" "Toggle Dwindle | Master Layout" "Hyprland Layout" \
" Shift F" "Toggle float" "single window" \
" ALT F" "Toggle all windows to float" "all windows" \
" SHIFT G" "Gamemode! All animations OFF or ON" "toggle" \
" Shift B" "Toggle Blur" "normal or less blur" \
" H" "Launch this app" "" \
" E" "View or EDIT Keybinds, Settings, Monitor" "" \
"" "" "" \
"More tips:" "https://github.com/AXWTV/Hyprland-DotFiles/wiki" ""\
