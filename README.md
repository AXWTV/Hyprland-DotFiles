<div align="center">

# ----- AXWTV-HYPRLAND-DOTFILE -----

<a href="https://github.com/D3Ext/aesthetic-wallpapers/stargazers">
    <img alt="Stargazers" src="https://img.shields.io/github/stars/AXWTV/Hyprland-DotFiles?style=for-the-badge&logo=starship&color=B5E8E0&logoColor=D9E0EE&labelColor=302D41"></a>
  <a href="https://github.com/AXWTV/Hyprland-DotFiles/graphs/contributors">
    <img alt="Contributors" src="https://img.shields.io/github/contributors/AXWTV/Hyprland-DotFiles?style=for-the-badge&logo=gitbook&color=B5E8E0&logoColor=D9E0EE&labelColor=302D41"></a>
  <a href="https://lbesson.mit-license.org/">
    <img alt="License" src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge&color=B5E8E0&logoColor=D9E0EE&labelColor=302D41"></a>
  <a herf="https://github.com/AXWTV/Hyprland-DotFiles/commits/main">
    <img alt="last-commit" src="https://img.shields.io/github/last-commit/AXWTV/Hyprland-DotFiles?style=for-the-badge&logo=github&logoColor=D9E0EE&labelColor=302D41"></a> 
    
<br/>
</div>

## ✨ Copying instructions. 
- Note! The auto copy script will create backups of intended folders to be copied. However, still a good idea to manually backup just incase script failed to backup!

- ~/.config (btop cava dunst hypr kitty rofi swappy swaylock waybar wlogout) - These are folders to be copied.
- ~/Pictures/wallpapers - Will be backed up

### 🔔 Automatic copy of configurations
clone this repo by using git. Change directory, make executable and run the script
```bash
git clone https://github.com/AXWTV/Hyprland-DotFiles.git
cd Hyprland-Dots
```
to copy from upstream (possible bugs)
```bash
chmod +x copy.sh
./copy.sh
```
to copy from releases (more "stable")
```bash
chmod +x release.sh
./release.sh
```
