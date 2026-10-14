#!/usr/bin/env bash

# Detener el script si ocurre algún error
set -e

# Colores para la terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}[*] Iniciando el setup de Arch-Dotfiles...${NC}"

# 1. Asegurar que el sistema está actualizado y con las herramientas base
echo -e "${BLUE}[*] Verificando dependencias esenciales (pacman)...${NC}"
sudo pacman -Syu --needed --noconfirm git ansible base-devel

# 2. Instalar la colección de Ansible para soporte de AUR si no existe
echo -e "${BLUE}[*] Configurando dependencias de Ansible...${NC}"
if ! ansible-galaxy collection list | grep -q 'kewlfft.aur'; then
  ansible-galaxy collection install kewlfft.aur
fi

# 3. Moverse al directorio del playbook y ejecutar Ansible
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PLAYBOOK_DIR="$SCRIPT_DIR/hardening_arch"

if [ -d "$PLAYBOOK_DIR" ]; then
  echo -e "${GREEN}[+] Ejecutando el flujo de Ansible...${NC}"
  cd "$PLAYBOOK_DIR"
  # Se usa -K para pedir la contraseña de sudo una sola vez al inicio
  ansible-playbook -K harden_arch.yml
else
  echo -e " error: No se encontró la carpeta hardening_arch en $SCRIPT_DIR"
  exit 1
fi

echo -e "${GREEN}[+] ¡Todo listo! Tu sistema ha sido configurado con éxito.${NC}"
