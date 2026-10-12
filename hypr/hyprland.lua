--------------------------------------------------------------------------------
--                                  MONITORS
--------------------------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Monitors/
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

--------------------------------------------------------------------------------
--                                 AUTOSTART
--------------------------------------------------------------------------------
-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
hl.on("hyprland.start", function()
	hl.exec_cmd("dunst")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("waybar")
end)

--------------------------------------------------------------------------------
--                                   STYLE
--------------------------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Variables/#general
hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 8,
		border_size = 2,
		-- https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
		col = {
			active_border = {
				colors = {
					"rgba(33ccffee)",
					"rgba(00ff99ee)",
				},
				angle = 45,
			},
			inactive_border = "rgba(595959aa)",
		},
		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,
		-- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
		allow_tearing = false,
		layout = "master",
	},
	-- https://wiki.hypr.land/Configuring/Variables/#decoration
	decoration = {
		rounding = 5,
		rounding_power = 5,
		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 0.9,

		shadow = {
			enabled = false,
		},
		-- https://wiki.hypr.land/Configuring/Variables/#blur
		blur = {
			enabled = true,
			size = 6,
			passes = 2,
			new_optimizations = true,
		},
	},
	-- https://wiki.hypr.land/Configuring/Variables/#animations
	animations = {
		enabled = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = false,
	},

	input = {
		kb_layout = "us,se,br",
		kb_variant = "",
		kb_model = "",
		kb_options = "ctrl:nocaps,grp:win_space_toggle",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

--------------------------------------------------------------------------------
--                              ANIMATION CURVES
--------------------------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Variables/#animations
hl.curve("easeOutQuint", {
	type = "bezier",
	points = {
		{ 0.23, 1 },
		{ 0.32, 1 },
	},
})

hl.curve("easeInOutCubic", {
	type = "bezier",
	points = {
		{ 0.65, 0.05 },
		{ 0.36, 1 },
	},
})

hl.curve("linear", {
	type = "bezier",
	points = {
		{ 0, 0 },
		{ 1, 1 },
	},
})

hl.curve("almostLinear", {
	type = "bezier",
	points = {
		{ 0.5,  0.5 },
		{ 0.75, 1 },
	},
})

hl.curve("quick", {
	type = "bezier",
	points = {
		{ 0.15, 0 },
		{ 0.1,  1 },
	},
})

--------------------------------------------------------------------------------
--                                 ANIMATIONS
--------------------------------------------------------------------------------
-- Default animations, see https://wiki.hypr.land/Configuring/Animations/
local animations = {
	{ "global",        10,   "default" },
	{ "border",        5.39, "easeOutQuint" },
	{ "windows",       4.79, "easeOutQuint" },
	{ "windowsIn",     4.1,  "easeOutQuint", "popin 87%" },
	{ "windowsOut",    1.49, "linear",       "popin 87%" },
	{ "fadeIn",        1.73, "almostLinear" },
	{ "fadeOut",       1.46, "almostLinear" },
	{ "fade",          3.03, "quick" },
	{ "layers",        3.81, "easeOutQuint" },
	{ "layersIn",      4,    "easeOutQuint", "fade" },
	{ "layersOut",     1.5,  "linear",       "fade" },
	{ "fadeLayersIn",  1.79, "almostLinear" },
	{ "fadeLayersOut", 1.39, "almostLinear" },
	{ "workspaces",    1.94, "almostLinear", "fade" },
	{ "workspacesIn",  1.21, "almostLinear", "fade" },
	{ "workspacesOut", 1.94, "almostLinear", "fade" },
	{ "zoomFactor",    7,    "quick" },
}
for _, a in ipairs(animations) do
	hl.animation({
		enabled = true,
		bezier = a[3],
		leaf = a[1],
		speed = a[2],
		style = a[4],
	})
end

--------------------------------------------------------------------------------
--                                  GESTURES
--------------------------------------------------------------------------------
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

--------------------------------------------------------------------------------
--                                  COMMANDS
--------------------------------------------------------------------------------
local terminal = "alacritty"
local lock = "hyprlock"
local menu = "wofi --show run"
local fileManager = "pcmanfm"
local screenshot = "flameshot"

--------------------------------------------------------------------------------
--                                KEYBINDINGS
--------------------------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Keywords/
local mainMod = "ALT"
-- General settings
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + p", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + p", hl.dsp.exec_cmd(menu .. " --matching fuzzy"))
hl.bind(mainMod .. " + s", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + e", hl.dsp.exec_cmd(fileManager .. ' "$HOME"'))
hl.bind(mainMod .. " + q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + q", function() hl.dispatch(hl.dsp.exit()) end)
-- Set modes
hl.bind(mainMod .. " + f", hl.dsp.window.float({ action = "set" }))
hl.bind(mainMod .. " + t", hl.dsp.window.float({ action = "unset" }))
hl.bind(mainMod .. " + m", hl.dsp.window.fullscreen({
	action = "set",
	mode = "maximized",
}))
-- Move around monitors
hl.bind(mainMod .. " + COMMA", function() hl.dispatch(hl.dsp.focus({ monitor = "l" })) end)
hl.bind(mainMod .. " + PERIOD", function() hl.dispatch(hl.dsp.focus({ monitor = "r" })) end)
-- Move around windows
hl.bind(mainMod .. " + j", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + k", hl.dsp.window.cycle_next({ next = false }))
hl.bind(mainMod .. " + RETURN", hl.dsp.layout("swapwithmaster"))
hl.bind(mainMod .. " + d", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + i", hl.dsp.layout("removemaster"))
hl.bind(mainMod .. " + SHIFT + COMMA", hl.dsp.window.move({ monitor = "l", follow = true }))
hl.bind(mainMod .. " + SHIFT + PERIOD", hl.dsp.window.move({ monitor = "r", follow = true }))
-- Resize windows
hl.bind(mainMod .. " + h", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mainMod .. " + l", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))

local workspaceKeys = {
	{ "1", "1" },
	{ "2", "2" },
	{ "3", "3" },
	{ "4", "4" },
	{ "5", "5" },
	{ "6", "6" },
	{ "7", "7" },
	{ "8", "8" },
	{ "9", "9" },
	{ "0", "10" },
}
for _, w in ipairs(workspaceKeys) do
	-- Switch workspaces with mainMod + [0-9]
	hl.bind(mainMod .. " + " .. w[1], hl.dsp.focus({ workspace = w[2] }))
	-- Move active window to a workspace with mainMod + SHIFT + [0-9]
	hl.bind(mainMod .. " + SHIFT + " .. w[1], hl.dsp.window.move({
		workspace = w[2],
		follow = false,
	}))
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- Multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

--------------------------------------------------------------------------------
-- WINDOW RULES
--------------------------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules
hl.window_rule({
	match = {
		class = "spotify",
	},
	workspace = "9 silent",
})
