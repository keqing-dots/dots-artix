-- HYPRLAND CONFIG

local V, F = require("utils.variables"), require("utils.functions")

-- =====================
-- ENVIRONMENT VARIABLES
-- =====================
F.map_env({
	-- Core
	KEQING_DOTS_ROOT = V.root,
	WORKSPACES_PER_MONITOR = V.wpm,

	-- Cursor themes
	HYPRCURSOR_THEME = "Keqing",
	HYPRCURSOR_SIZE = "24",
	XCURSOR_THEME = "Keqing",
	XCURSOR_SIZE = "24",

	-- Input method
	QT_IM_MODULE = "fcitx5",
	XMODIFIERS = "@im=fcitx5",
	INPUT_METHOD = "fcitx5",
	SDL_IM_MODULE = "fcitx5",

	-- Toolkit
	XDG_MENU_PREFIX = "artix-",
	QT_QPA_PLATFORMTHEME = "qt6ct",
	GTK_THEME = "Adwaita:dark",
	GTK_APPLICATION_PREFER_DARK_THEME = "1",
	QT_STYLE_OVERRIDE = "Fusion",
	QT_QUICK_CONTROLS_STYLE = "Fusion",
	QT_THEME = "dark",

	-- Session
	XDG_CURRENT_DESKTOP = "Hyprland",
	XDG_SESSION_DESKTOP = "Hyprland",
	XDG_SESSION_TYPE = "wayland",

	-- Wayland
	QT_QPA_PLATFORM = "wayland;xcb",
	GDK_BACKEND = "wayland,x11",
	MOZ_ENABLE_WAYLAND = "1",
	GTK_USE_PORTAL = "1",
})

-- ==========
-- ANIMATIONS
-- ==========
F.map_curves({
	quick = { { 0.15, 0 }, { 0.1, 1 } },
	linear = { { 0, 0 }, { 1, 1 } },
})

F.map_anim({
	{ leaf = "global", enabled = false },
	{ leaf = "fadeIn", speed = 1.5, bezier = "linear" },
	{ leaf = "fadeOut", speed = 1.5, bezier = "linear" },
	{ leaf = "windowsIn", speed = 1.5, bezier = "linear", style = "popin 85%" },
	{ leaf = "windowsOut", speed = 1.5, bezier = "linear", style = "popin 85%" },
	{ leaf = "windowsMove", speed = 2.0, bezier = "quick" },
	{ leaf = "workspaces", speed = 2.5, bezier = "quick", style = "slidevert" },
})

-- ========
-- SETTINGS
-- ========
hl.config({
	general = {
		border_size = 5,
		allow_tearing = false,
		gaps_in = 10,
		gaps_out = 20,
		resize_on_border = true,

		col = {
			active_border = { colors = { V.col.accent .. "EE", V.col.lavender .. "EE" }, angle = 45 },
			inactive_border = V.col.textDim .. "AA",
		},
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = true,
	},

	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			tap_to_click = true,
			drag_lock = 0,
			scroll_factor = 1.0,
		},
	},

	cursor = {
		enable_hyprcursor = true,
		no_hardware_cursors = 1,
		use_cpu_buffer = 2,
	},

	misc = {
		animate_mouse_windowdragging = true,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		middle_click_paste = false,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})

-- ======================
-- INITIAL MONITOR CONFIG
-- ======================
F.set_monitor("", "preferred", "0x0", 1, 0)

-- ========
-- GESTURES
-- ========
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- ============
-- WINDOW RULES
-- ============
hl.window_rule({ match = { fullscreen = true }, border_color = V.col.accentAlt })
hl.window_rule({ match = { float = true }, border_color = V.col.text })
for _, i in ipairs({ "code", "code-oss", "codium" }) do
	hl.window_rule({ match = { class = i }, opacity = "0.7" })
end
-- ===========
-- KEYBINDINGS
-- ===========
F.map_keybinds(nil, {
	["SUPER + F"] = hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
	["SUPER + I"] = F.exec(V.settings),
	["SUPER + L"] = F.exec(V.lock),
	["SUPER + P"] = hl.dsp.window.pseudo(),
	["SUPER + Q"] = F.exec(V.logout),
	["SUPER + V"] = hl.dsp.window.float({ action = "toggle" }),
	["SUPER + ALT + K"] = F.exec(V.editor .. " keqing-shell"),
	["SUPER + CTRL + SHIFT + W"] = F.exec(V.cw .. "a"),
	["SUPER + SHIFT + F"] = hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	["SUPER + SHIFT + K"] = F.exec(V.editor .. " keqing-dots"),
	["SUPER + SHIFT + S"] = F.exec(V.screenshot),
	["SUPER + SHIFT + W"] = F.exec(V.cw),
	["SHIFT + SPACE"] = F.exec(V.launcher),
	["SUPER + TAB"] = F.exec(V.overview),
})

F.map_keybinds({ repeating = true }, {
	["SUPER + B"] = F.exec(V.browser),
	["SUPER + C"] = F.exec(V.editor),
	["SUPER + E"] = F.exec(V.filemanager),
	["SUPER + T"] = F.exec(V.terminal),
	["SUPER + W"] = hl.dsp.window.close(),
	["SUPER + SHIFT + B"] = F.exec(V.browser_private),
})

F.map_keybinds({ repeating = true }, {
	["SUPER + up"] = hl.dsp.focus({ direction = "u" }),
	["SUPER + down"] = hl.dsp.focus({ direction = "d" }),
	["SUPER + left"] = hl.dsp.focus({ direction = "l" }),
	["SUPER + right"] = hl.dsp.focus({ direction = "r" }),
	["SUPER + ALT + up"] = hl.dsp.window.resize({ x = 0, y = -20, relative = true }),
	["SUPER + ALT + down"] = hl.dsp.window.resize({ x = 0, y = 20, relative = true }),
	["SUPER + ALT + left"] = hl.dsp.window.resize({ x = -20, y = 0, relative = true }),
	["SUPER + ALT + right"] = hl.dsp.window.resize({ x = 20, y = 0, relative = true }),
	["SUPER + SHIFT + up"] = hl.dsp.window.move({ direction = "u" }),
	["SUPER + SHIFT + down"] = hl.dsp.window.move({ direction = "d" }),
	["SUPER + SHIFT + left"] = hl.dsp.window.move({ direction = "l" }),
	["SUPER + SHIFT + right"] = hl.dsp.window.move({ direction = "r" }),
})

for i = 1, V.wpm do
	local k = i % V.wpm
	hl.bind("SUPER + " .. k, F.exec(V.fw .. i))
	hl.bind("SUPER + CTRL + " .. k, F.exec(V.sw .. i))
	hl.bind("SUPER + SHIFT + " .. k, F.exec(V.mw .. i))
end

F.map_keybinds({ locked = true, repeating = true }, {
	["XF86AudioRaiseVolume"] = F.exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"),
	["XF86AudioLowerVolume"] = F.exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),
	["XF86AudioMicMute"] = F.exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	["XF86AudioMute"] = F.exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	["XF86MonBrightnessDown"] = F.exec("brightnessctl -e4 -n2 set 1%-"),
	["XF86MonBrightnessUp"] = F.exec("brightnessctl -e4 -n2 set 1%+"),
})

F.map_keybinds({ mouse = true }, {
	["SUPER + mouse:272"] = hl.dsp.window.drag(),
	["SUPER + mouse:273"] = hl.dsp.window.resize(),
})

F.auto_start({
	"pipewire",
	"wireplumber",
	"fcitx5",
	"keqing-shell start_locked",
})

F.load_device()
