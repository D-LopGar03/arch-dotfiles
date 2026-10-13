---@module 'hl'

--###############

--## MONITORS ###

--###############

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60",
	position = "auto",
	scale = 1,
})

--monitor = HDMI-A-1,1440x900@60, auto, auto

hl.monitor({
	output = "VIRTUAL-1",
	mode = "1920x1080",
	position = "auto",
	scale = 1,
})

-- apps libadwaita gtk4:

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- para apps Qt # Tema

hl.env("QT_QPA_PLATFORMTHEME", "kvantum")

hl.env("QT_STYLE_OVERRIDE", "kvantum")

hl.env("XCURSOR_THEME", "GTAFinger")

hl.env("XCURSOR_SIZE", 48)

--##################

--## MY PROGRAMS ###

--##################

local terminal = "kitty"

local fileManager = "dolphin"

local menu = 'os.getenv("HOME")/.config/scripts/./rofi.sh'

local browser = "vivaldi"

local textEditor = "code"

local sniff = "wireshark"

local passManager = "keepassxc"

local mdText = "obsidian"

local screenLock = 'os.getenv("HOME")/.config/scripts/./screen_lock.sh'

local toggleMic = 'os.getenv("HOME")/.config/scripts/./toggle-mic.sh'

--###########################

--## ENVIRONMENT VARIABLES ###

--############################

-- ── GTK Dark Theme ──────────────────────

hl.env("GTK_THEME", "Adwaita:dark")

hl.env("GDK_SCALE", 1)

hl.env("QT_QPA_PLATFORM", "xcb")

-- ── QT Dark Theme via Kvantum ───────────

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

hl.env("QT_STYLE_OVERRIDE", "kvantum")

hl.env("QT_QPA_PLATFORM", "wayland")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", 1)

hl.env("QT_WAYLAND_DISABLE_WINDOW_DECORATION", 1)

--env = QT_QPA_PLUGIN, xcb

-- ANDROID

hl.env("QT_QPA_PLATFORM", "xcb")

hl.env("ANDROID_AVD_HOME", "/home/ay4t0/.config/.android/avd")

hl.env("_JAVA_AWT_WM_NONREPARENTING", 1)

hl.env("ANDROID_HOME", "/home/ay4t0/Android/Sdk")

hl.env("ANDROID_SDK_ROOT", "/home/ay4t0/Android/Sdk")

-- ── Cursor Settings ─────────────────────

hl.env("XCURSOR_SIZE", 48)

hl.env("HYPRCURSOR_SIZE", 48)

-- ── Wayland Apps ────────────────────────

hl.env("MOZ_ENABLE_WAYLAND", 1)

hl.env("SDL_AUDIODRIVER", "pipewire")

--####################

--## LOOK AND FEEL ###

--####################

hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 5,
		border_size = 1,
		-- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,
		-- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
		allow_tearing = false,
		layout = "dwindle",
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},
})

hl.config({
	decoration = {
		rounding = 0,
		rounding_power = 0,
		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 0.8,

		blur = {
			enabled = true,
			size = 9,
			passes = 2,
			vibrancy = 9,
		},
	},
})

hl.config({
	animations = {
		enabled = true,
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	misc = {
		force_default_wallpaper = -1,
		-- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false,
		initial_workspace_tracking = false,
		-- If true disables the random hyprland logo / anime girl background. :(
	},
})

--####################################
--### Disable startup maximization ###
--####################################

hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

--############

--## INPUT ###

--############

hl.config({
	input = {
		kb_layout = "latam",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

--##################

--## KEYBINDINGS ###

--##################

local mainMod = "ALT"

local altMod = "MOD4"

hl.bind(mainMod .. " + " .. "Q", hl.dsp.exec_cmd("kitty"))

hl.bind(mainMod .. " + " .. "C", hl.dsp.window.close())

hl.bind(mainMod .. " + " .. "M", hl.dsp.exit())

hl.bind(mainMod .. " + " .. "E", hl.dsp.exec_cmd("dolphin"))

hl.bind(mainMod .. " + " .. "V", hl.dsp.window.float())

hl.bind(mainMod .. " + " .. "R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/scripts/./rofi.sh"))

hl.bind(mainMod .. " + " .. "P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + " .. "B", hl.dsp.exec_cmd("vivaldi"))

hl.bind(" + " .. altMod .. " + " .. "R", hl.dsp.exec_cmd("reboot"))

hl.bind(" + " .. altMod .. " + " .. "A", hl.dsp.exec_cmd("poweroff"))

hl.bind(
	" + " .. altMod .. " + " .. "F",
	hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/scripts/waypaper_change_wallpaper.sh")
)

hl.bind(" + " .. altMod .. " + " .. "C", hl.dsp.exec_cmd("code"))

hl.bind(mainMod .. " + " .. "K", hl.dsp.exec_cmd("keepassxc"))

hl.bind(mainMod .. " + " .. "O", hl.dsp.exec_cmd("obsidian"))

hl.bind(
	mainMod .. " + " .. "SHIFT" .. " + " .. "L",
	hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/scripts/./screen_lock.sh")
)

hl.bind(mainMod .. " + " .. "W", hl.dsp.exec_cmd("wireshark"))

hl.bind(
	mainMod .. " + " .. "SHIFT" .. " + " .. "S",
	hl.dsp.exec_cmd("hyprshot -m region --output-folder ~/Pictures/Screenshots")
)

-- Mic toggle

hl.bind("F9", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/scripts/./toggle-mic.sh"), { locked = true })

-- Multimedia keybinds

hl.bind("F10", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("F11", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

hl.bind("F12", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- Move focus with mainMod + arrow keys

hl.bind(mainMod .. " + " .. "left", hl.dsp.focus({ direction = "left" }))

hl.bind(mainMod .. " + " .. "right", hl.dsp.focus({ direction = "right" }))

hl.bind(mainMod .. " + " .. "up", hl.dsp.focus({ direction = "up" }))

hl.bind(mainMod .. " + " .. "down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]

hl.bind(mainMod .. " + " .. 1, hl.dsp.focus({ workspace = 1 }))

hl.bind(mainMod .. " + " .. 2, hl.dsp.focus({ workspace = 2 }))

hl.bind(mainMod .. " + " .. 3, hl.dsp.focus({ workspace = 3 }))

hl.bind(mainMod .. " + " .. 4, hl.dsp.focus({ workspace = 4 }))

hl.bind(mainMod .. " + " .. 5, hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + " .. 6, hl.dsp.focus({ workspace = 6 }))

hl.bind(mainMod .. " + " .. 7, hl.dsp.focus({ workspace = 7 }))

hl.bind(mainMod .. " + " .. 8, hl.dsp.focus({ workspace = 8 }))

hl.bind(mainMod .. " + " .. 9, hl.dsp.focus({ workspace = 9 }))

hl.bind(mainMod .. " + " .. 0, hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 1, hl.dsp.window.move({ workspace = 1 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 2, hl.dsp.window.move({ workspace = 2 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 3, hl.dsp.window.move({ workspace = 3 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 4, hl.dsp.window.move({ workspace = 4 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 5, hl.dsp.window.move({ workspace = 5 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 6, hl.dsp.window.move({ workspace = 6 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 7, hl.dsp.window.move({ workspace = 7 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 8, hl.dsp.window.move({ workspace = 8 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 9, hl.dsp.window.move({ workspace = 9 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 0, hl.dsp.window.move({ workspace = 10 }))

-- Resize left (decrease width / move left border)
hl.bind(mainMod .. "+" .. "TAB + LEFT", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })

-- Resize right (increase width)
hl.bind(mainMod .. "+" .. "TAB + RIGHT", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })

-- Resize up (decrease height)
hl.bind(mainMod .. "+" .. "TAB + UP", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })

-- Resize down (increase height)
hl.bind(mainMod .. "+" .. "TAB + DOWN", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- Move left or right a window through same workspace or different workspaces

hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))

hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))

hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))

-- Move through workspaces one by one

hl.bind(altMod .. " + " .. "left", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(altMod .. " + " .. "right", hl.dsp.focus({ workspace = "e+1" }))

-- Example special workspace (scratchpad)

hl.bind(mainMod .. " + " .. "S", hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "P", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll

hl.bind(mainMod .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD bightness

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true })

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), { locked = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { locked = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true })

hl.layer_rule({
	match = {
		namespace = "^(waybar)$",
	},
	no_anim = true,
})

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet &")
	hl.exec_cmd("waybar")
	hl.exec_cmd("awww-daemon --format xrgb")
	hl.exec_cmd("~/.config/scripts/is-playing.py")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all QT_QPA_PLATFORM ANDROID_AVD_HOME")
end)

-- Exec (run every reload)
hl.on("config.reloaded", function()
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3")
end)
