#!/bin/bash

BASE_DIR="$HOME/.config/wallpapers"

# Selección de carpeta
DIR=$(find -L "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d | sed "s|$BASE_DIR/||" | rofi -dmenu -p "📂 Carpeta")
[ -z "$DIR" ] && exit 0

# Construir lista de imágenes con opción de volver
IMAGES=$(find -L "$BASE_DIR/$DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.jpeg" -o -iname "*.webp" \))

CHOICE=$(
  (
    echo "🔙 Volver"
    for img in $IMAGES; do
      echo -en "$(basename "$img")\0icon\x1f$img\n"
    done
  ) | rofi -dmenu \
    -show-icons \
    -theme-str '
* {
  font: "Hack Nerd Font 12";
}
window {
  width: 75%;
  background-color: #1e1e2e;
  padding: 20px;
}
listview {
  lines: 4;
  columns: 4;
  spacing: 15px;
}
element {
  padding: 10px;
  border-radius: 12px;
}
element-icon {
  size: 180px;
}
'
)

# Nada elegido → salir
[ -z "$CHOICE" ] && exit 0

# Si eligió volver → relanzar
if [[ "$CHOICE" == "🔙 Volver" ]]; then
  exec "$0"
fi

# Recuperar la ruta completa a partir del nombre
IMG=$(find -L "$BASE_DIR/$DIR" -type f -iname "$CHOICE" | head -n1)

# Verificación
[ -z "$IMG" ] && exit 1

# Aplicar fondo
awww img "$IMG" --transition-type wave --transition-angle 180 --transition-duration 1.5 --filter Nearest --resize stretch
wal -n -s -i "$IMG"
