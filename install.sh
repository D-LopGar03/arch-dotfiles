#!/usr/bin/env bash

# Detener el script si ocurre algún error
set -e

# Colores para la terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

YAY_COMMIT="cb43f84828ab4f9700f7c6f9c6d7a923d4cfaff0"
YAY_PKGBUILD_SHA256="5c1cb01eca47edb4e4665d8734a23bd71d33ba240093ff5a125e0bb2daa8e473"
BUILD_DIR=""

cleanup() {
  [[ -n "$BUILD_DIR" && -d "$BUILD_DIR" ]] && rm -rf "$BUILD_DIR"
}
trap cleanup EXIT

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    echo -e "${GREEN}[+] yay ya está instalado, se omite.${NC}"
    return
  fi

  echo -e "${BLUE}[*] Compilando yay desde fuente (commit fijado)...${NC}"
  BUILD_DIR="$(mktemp -d /tmp/yay-build.XXXXXX)"

  git clone --quiet https://aur.archlinux.org/yay.git "$BUILD_DIR"
  git -C "$BUILD_DIR" checkout --quiet "$YAY_COMMIT"

  echo "${YAY_PKGBUILD_SHA256}  ${BUILD_DIR}/PKGBUILD" | sha256sum -c - ||
    {
      echo -e "${RED}[!] El PKGBUILD no coincide con el revisado. Abortando.${NC}"
      exit 1
    }

  (cd "$BUILD_DIR" && makepkg -f --noconfirm)

  local pkg
  pkg="$(cd "$BUILD_DIR" && makepkg --packagelist | grep -v -- '-debug-' | head -n1)"
  sudo pacman -U --noconfirm "$pkg"
}

install_aur_pkg() {
  local pkg="$1"

  if pacman -Qi "$pkg" >/dev/null 2>&1; then
    echo -e "${GREEN}[+] $pkg ya está instalado, se omite.${NC}"
    return
  fi

  if ! yay -Si "$pkg" >/dev/null 2>&1; then
    echo -e "${RED}[!] $pkg no existe en los repos ni en AUR. Abortando.${NC}"
    exit 1
  fi

  echo -e "${BLUE}[*] Instalando $pkg desde AUR (revisa el PKGBUILD cuando yay lo pida)...${NC}"
  yay -S --needed "$pkg" # sin --noconfirm, a propósito
}

echo -e "${BLUE}[*] Iniciando el setup de Arch-Dotfiles...${NC}"

# 1. Dependencias esenciales
echo -e "${BLUE}[*] Verificando dependencias esenciales (pacman)...${NC}"
sudo pacman -Syu --needed --noconfirm git ansible base-devel go

# 2. yay (commit fijado y verificado)
install_yay
install_aur_pkg python-pywal
install_aur_pkg candy-icons-git

# 3. Moverse al directorio del playbook y ejecutar Ansible
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PLAYBOOK_DIR="$SCRIPT_DIR/hardening_arch"

if [ -d "$PLAYBOOK_DIR" ]; then
  echo -e "${GREEN}[+] Ejecutando el flujo de Ansible...${NC}"
  cd "$PLAYBOOK_DIR"
  # Se usa -K para pedir la contraseña de sudo una sola vez al inicio
  ansible-playbook -K harden_arch.yml
else
  echo -e "${RED}error: No se encontró la carpeta hardening_arch en $SCRIPT_DIR${NC}"
  exit 1
fi

echo -e "${GREEN}[+] ¡Todo listo! Tu sistema ha sido configurado con éxito.${NC}"

echo -e "${GREEN} [+] Se reiniciará el sistema en 5 segundos..."

sleep 5
reboot
