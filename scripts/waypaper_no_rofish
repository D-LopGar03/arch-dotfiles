#!/bin/zsh

# This script is executed by crontab every 5 minutes
# */5 * * * * /home/ay4t0/.config/scripts/waybar_change_wallpaper.sh


# Carpeta donde tienes tus fondos de pantalla
wallpaper_dir="$HOME/.config/wallpapers/pixel-arts/"

# Seleccionar un archivo de imagen aleatorio de la carpeta (incluye más extensiones)
wallpaper=$(find "$wallpaper_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1)

# Cambiar el fondo con Waypaper
swww img "$wallpaper" --transition-duration=0 && wal -i "$wallpaper" && killall waybar && waybar &

sleep 5

