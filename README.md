# Arch Linux Dotfiles - Entorno Hyprland Personalizado & Hardening Base

Este repositorio contiene la configuración automatizada y los archivos de personalización para un entorno de escritorio moderno, minimalista y fluido en **Arch Linux** basado en el compositor Wayland **Hyprland**, combinado con políticas esenciales de **endurecimiento de seguridad (Hardening)**.

La configuración del compositor se gestiona mediante una capa de abstracción en Lua (`hl.*`) que optimiza la carga de variables de entorno, atajos de teclado y la gestión avanzada de monitores.

---

## 🛠️ Cómo Funciona el Entorno

El sistema operativo inicializa los servicios esenciales y levanta el servidor gráfico utilizando las siguientes directrices:

### 1. Gestión de Pantallas y Monitores
El archivo central configura tres perfiles de salida de video predeterminados de forma dinámica:
*   **eDP-1:** Pantalla principal de laptop configurada a `1920x1080@60Hz`.
*   **HDMI-A-1:** Monitor externo configurado en modo automático (`auto`).
*   **VIRTUAL-1:** Monitor virtual de respaldo para streaming o virtualización.

### 2. Integración Visual y Temas (Qt/GTK)
Para resolver la inconsistencia visual de las aplicaciones nativas en Wayland, se fuerza un entorno unificado oscuro:
*   **GTK 3/4:** Utiliza el esquema oscuro nativo `Adwaita:dark` a través de reglas integradas de GNOME.
*   **Qt 5/6:** Se configuran las plataformas `qt6ct` y el motor de estilos `Kvantum` para renderizar ventanas oscuras coherentes.

### 3. Automatización al Inicio (Autostart)
Al iniciar la sesión, se ejecutan en segundo plano los siguientes demonios nativos:
*   `nm-applet`: Indicador de red en la barra del sistema.
*   `waybar`: Barra de tareas y estado del sistema.
*   `awww-daemon`: Gestor de fondos de pantalla optimizado.
*   `hypridle`: Gestión de suspensión y ahorro de energía.

---

## 🔒 Hardening del Sistema (Seguridad Básica)

Este entorno implementa directrices de seguridad críticas para mitigar vectores de ataque comunes en estaciones de trabajo Linux:

*   **Desactivación de Módulos del Kernel Obsoletos:** Se bloquea la carga automática de módulos antiguos, no utilizados o vulnerables del kernel (como esquemas de archivos atípicos, protocolos de red en desuso o drivers de hardware heredados) reduciendo la superficie de ataque del espacio del kernel.
*   **Protección de Memoria Compartida (`/dev/shm`):** Se monta el directorio `/dev/shm` con las opciones `noexec, nosuid, nodev`. Esto **impide la ejecución de binarios o scripts maliciosos** directamente desde la memoria compartida temporal del sistema.
*   **Máscara de Permisos Global (`UMASK 027`):** Configurada de forma estricta en `/etc/login.defs`, `/etc/profile` y `/etc/csh.cshrc`. Cualquier archivo o directorio nuevo creado por un usuario limitará los permisos de lectura/escritura/ejecución al propietario y a su grupo primario, denegando el acceso absoluto al resto del sistema (*others*).
*   **Restricción del Sistema Cron:** Se cambian los permisos y la propiedad de los directorios y archivos de tareas programadas (`cron`, `crontab`, `/etc/cron.*`) para que **únicamente el usuario `root`** tenga permisos de lectura y ejecución, previniendo escaladas de privilegios locales a través de scripts de tareas.

---

## 📦 Paquetes del Sistema

### Paquetes Nativos (Pacman)
El sistema instala un ecosistema completo para desarrollo, multimedia y administración:

*   **Core & Entorno:** `waybar`, `rofi`, `swaync`, `hyprlock`, `hypridle`, `hyprshot`.
*   **Sistema y Audio:** `networkmanager`, `network-manager-applet`, `tlp`, `alsa-utils`, `alsa-ucm-conf`, `alsa-card-profiles`, `sof-firmware`.
*   **Productividad & Notas:** `obsidian`, `libreoffice-fresh`, `keepassxc`, `vivaldi`, `digikam`.
*   **Herramientas CLI:** `zsh`, `nvim`, `ranger`, `cava`, `rsync`, `imagemagick`, `poppler`.
*   **Virtualización:** `virtualbox`, `virtualbox-host-dkms`.
*   **Fuentes e Iconos:** `ttf-hack-nerd`, `ttf-nerd-fonts-symbols`, `ttf-meslo-nerd`, `noto-fonts-emoji`, `papirus-icon-theme`.
*   **Librerías Gráficas:** `gtk3`, `gtk4`, `qt6ct`, `breeze`, `kvantum`, `kde-cli-tools`, `kdeconnect`.

### Sandbox Aislado (Flatpak)
Ciertas aplicaciones críticas se ejecutan de forma aislada para mayor seguridad:
*   `com.brave.Browser` (Navegador principal seguro).
*   `com.vscodium.codium` (Editor de código Open Source libre de telemetría).
*   `com.github.tchx84.Flatseal` (Utilidad para gestionar y recortar permisos de las apps Flatpak).

---

## ⌨️ Atajos de Teclado Clave (Keybindings)

El modificador principal está configurado en la tecla **`ALT`** (`mainMod`) y el secundario en la tecla **`SUPER/META`** (`altMod`).

*   `ALT + Q` ── Abrir Terminal (`kitty`)
*   `ALT + B` ── Abrir Navegador (`Brave Browser`)
*   `ALT + E` ── Abrir Gestor de Archivos (`dolphin`)
*   `ALT + R` ── Lanzar Menú de Aplicaciones (`rofi`)
*   `ALT + C` ── Cerrar ventana enfocada
*   `ALT + SHIFT + L` ── Bloquear Pantalla (`hyprlock`)
*   `ALT + SHIFT + S` ── Captura de pantalla de una región (`hyprshot`)
*   `SUPER + R` ── Reiniciar el sistema
*   `SUPER + A` ── Apagar el equipo
