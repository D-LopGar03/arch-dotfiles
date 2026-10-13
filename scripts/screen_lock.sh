#!/bin/zsh

wallpaper_dir="$HOME/.config/wallpapers/"

random_dir=$(find "$wallpaper_dir" -type d | shuf -n 1)

wallpaper=$(find "$random_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

# Escribir el wallpaper en el config dinámicamente
sed -i "s|path = .*|path = $wallpaper|" ~/.config/hypr/hyprlock.conf

hyprlock

