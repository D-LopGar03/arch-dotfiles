# Arch Linux Dotfiles - Entorno Hyprland Personalizado & Hardening Base

Este repositorio contiene la configuración automatizada y los archivos de personalización para un entorno de escritorio moderno, minimalista y fluido en **Arch Linux** basado en el compositor Wayland **Hyprland**, combinado con políticas esenciales de **endurecimiento de seguridad (Hardening)** y optimización inteligente de energía.

La configuración del compositor se gestiona mediante una capa de abstracción en Lua (`hl.*`) que optimiza la carga de variables de entorno, atajos de teclado y la gestión avanzada de monitores.

---

## 🛠️ Cómo Funciona el Entorno

El sistema operativo inicializa los servicios esenciales y levanta el servidor gráfico utilizando las siguientes directrices:

### 1. Gestión de Pantallas y Monitores
El archivo de configuración detecta y levanta tres perfiles de salida de video predeterminados de forma dinámica:
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

## 💤 Gestión de Inactividad (`hypridle.conf`)

El ahorro de energía y la seguridad física del equipo se orquestan mediante **`hypridle`** de forma escalonada a través de tres escuchas de tiempo (*listeners*):

1.  **Atenuación de Pantalla (100 segundos):** Si no hay actividad, reduce el brillo al mínimo (`5%`) mediante `brightnessctl`. Al detectar movimiento, restablece de inmediato un brillo cómodo del `30%`.
2.  **Bloqueo y Apagado de Panel (120 segundos):** Tras 2 minutos de inactividad, invoca de forma segura el script ejecutable de bloqueo `~/.config/scripts/screen_lock.sh`. Al regresar el usuario, ejecuta el despacho de control `hyprctl dispatch dpms on` para reactivar físicamente la señal de vídeo de las pantallas.
3.  **Suspensión Profunda (300 segundos):** Si el equipo permanece desatendido por 5 minutos, se ordena un estado de suspensión completa a nivel de sistema operativo (`systemctl suspend`), protegiendo el hardware y guardando la energía restante de la batería.

---

## 🔋 Optimización Inteligente de Batería (TLP + Ansible)

El aprovisionamiento integra un aprovisionamiento avanzado de **TLP** automatizado a través de Ansible para extender la vida útil de la batería sin perjudicar la fluidez de Hyprland:

### ⚙️ Automatización del Perfil de Energía
*   **Aislamiento de Conflictos:** El playbook detiene, deshabilita y enmascara (`masked: true`) servicios que interfieren de forma directa con la gestión de energía, específicamente `power-profiles-daemon.service`. Adicionalmente, bloquea `systemd-rfkill.service` y su socket para cederle el control de los interruptores de radio a `tlp-rdw`.
*   **Configuraciones Modificadas al Desconectar el Cargador (`on battery`):**
    *   Desactiva los perfiles de ráfaga de CPU (`CPU_BOOST_ON_BAT="0"` y `CPU_HWP_DYN_BOOST_ON_BAT="0"`) para mitigar picos térmicos.
    *   Forza el escalado del procesador a un modo conservador pero eficiente (`CPU_SCALING_GOVERNOR_ON_BAT="powersave"`).
    *   Ajusta la política de rendimiento de energía a un balance equilibrado hacia el ahorro (`CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power"`).
*   **Aplicación en Caliente:** Si la tarea detecta modificaciones en el archivo `/etc/tlp.conf`, el manual invoca de inmediato un comando `tlp start` para refrescar los parámetros del kernel en caliente sin requerir reinicios.

### 📐 Umbrales de Carga Dinámicos por Hardware
Para evitar la degradación prematura de las celdas de la batería al permanecer conectada a la corriente, el script evalúa el parámetro de fábrica del chasis (`ansible_facts['chassis_vendor']`) para aplicar umbrales de carga personalizados automáticamente:
*   **Laptops ASUS / ASUSTeK:** Limita la detención de la carga al llegar al **80%**.
*   **Laptops Lenovo / ThinkPad:** Establece el inicio de recarga al bajar del **75%** y la detención estricta al **80%**.
*   **Laptops Huawei:** Restringe el límite de carga superior al **80%**.
*   **Otros Fabricantes:** Mantiene los parámetros por defecto de manera segura.

---

## 🔒 Hardening del Sistema (Seguridad Básica)

Este entorno implementa directrices de seguridad críticas para mitigar vectores de ataque comunes en estaciones de trabajo Linux:

*   **Desactivación de Módulos del Kernel Obsoletos:** Se bloquea la carga automática de módulos antiguos, no utilizados o vulnerables del kernel (como esquemas de archivos atípicos, protocolos de red en desuso o drivers de hardware heredados) reduciendo la superficie de ataque del espacio del kernel.
*   **Protección de Memoria Compartida (`/dev/shm`):** Se monta el directorio `/dev/shm` con las opciones `noexec, nosuid, nodev`. Esto **impide la ejecución de binarios o scripts maliciosos** directamente desde la memoria compartida temporal del sistema.
*   **Máscara de Permisos Global (`UMASK 027`):** Configurada de forma estricta en `/etc/login.defs`, `/etc/profile` y `/etc/csh.cshrc`. Cualquier archivo o directorio nuevo creado por un usuario limitará los permisos de lectura/escritura/ejecución al propietario y a su grupo primario, denegando el acceso absoluto al resto del sistema (*others*).
*   **Restricción del Sistema Cron:** Se cambian los permisos y la propiedad de los directorios y archivos de tareas programadas (`cron`, `crontab`, `/etc/cron.*`) para que **únicamente el usuario `root`** tenga permisos de lectura y ejecución, previniendo escaladas de privilegios locales a través de scripts de tareas.

---

## 🚀 Instalación y Despliegue Automatizado

El repositorio incluye un script de automatización completo encargado de preparar el entorno de compilación, desplegar el gestor AUR con validaciones de seguridad estrictas y delegar las tareas complejas de hardening a un manual táctico de Ansible.

Para iniciar todo el aprovisionamiento del sistema, ejecuta el siguiente comando en la terminal:

```bash
bash install.sh
```

### 🔍 ¿Cómo funciona internamente `install.sh`?

El script se ejecuta bajo una política estricta de control de errores (`set -e`) y sigue secuencialmente estos pasos críticos:

1.  **Aprovisionamiento Inicial:** Invoca a `pacman` de forma nativa para actualizar los repositorios e instalar las dependencias base indispensables: `git`, `ansible`, `base-devel` (para compilar) y `go`.
2.  **Compilación Segura de `yay` (AUR Helper):**
    *   Si `yay` no está instalado en el sistema, lo descarga directamente del repositorio oficial de AUR.
    *   **Fijación de Commit:** Fuerza un `git checkout` al commit específico verificado de confianza (`cb43f84`).
    *   **Verificación Criptográfica:** Valida el archivo `PKGBUILD` local mediante una suma de comprobación **SHA-256**. Si el hash no coincide exactamente con la firma almacenada (`5c1cb01...`), el script aborta inmediatamente la instalación para prevenir ataques de inyección de código (*Supply Chain Attacks*).
3.  **Inyección de Paquetes AUR:** Compila e instala de forma controlada las herramientas visuales esenciales `python-pywal` y el paquete de iconos `candy-icons-git`.
4.  **Aislamiento y Limpieza:** El script genera un directorio temporal seguro en `/tmp` mediante `mktemp` para la compilación de binarios. Al finalizar con éxito o detectar un error, un disparador `trap EXIT` destruye automáticamente el residuo volátil del almacenamiento.
5.  **Ejecución de Ansible (Hardening & Configuración):**
    *   El script se desplaza al directorio local `hardening_arch/` y arranca la orquestación mediante:
        ```bash
        ansible-playbook -K harden_arch.yml
        ```
    *   La bandera `-K` (`--ask-become-pass`) garantiza que el sistema **solicite tu contraseña de superusuario (`sudo`) una única vez** al inicio del despliegue, aplicándola de forma segura en las subtareas del playbook sin exponerla en scripts.

---

## 📦 Paquetes del Sistema

### Paquetes Nativos (Pacman)
El sistema instala un ecosistema completo para desarrollo, multimedia y administración:

*   **Core & Entorno:** `waybar`, `rofi`, `swaync`, `hyprlock`, `hypridle`, `hyprshot`.
*   **Sistema y Audio:** `networkmanager`, `network-manager-applet`, `tlp`, `tlp-rdw`, `alsa-utils`, `alsa-ucm-conf`, `alsa-card-profiles`, `sof-firmware`.
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
*   `SUPER + F` ── Selector de fondos de pantalla (Ejecuta el script de control para `awww` en `~/.config/scripts/change_wallpaper.sh`)
*   `ALT + SHIFT + L` ── Bloquear Pantalla (`hyprlock`)
*   `ALT + SHIFT + S` ── Captura de pantalla de una región (`hyprshot`)
*   `SUPER + R` ── Reiniciar el sistema
*   `SUPER + A` ── Apagar el equipo

### 🎵 Control de Medios & Micrófono
*   `F9` ── Alternar silencio del micrófono. Llama al script `~/.config/scripts/toggle-mic.sh`, el cual extrae dinámicamente el ID del dispositivo de audio digital desde `wpctl status` y alterna su estado (*toggle mute*).
*   `F10` ── Retroceder canción (`playerctl previous`)
*   `F11` ── Pausar / Reproducir canción (`playerctl play-pause`)
*   `F12` ── Siguiente canción (`playerctl next`)

