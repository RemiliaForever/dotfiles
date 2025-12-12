local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.front_end = "WebGpu" -- 'OpenGL'
config.use_ime = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"

config.font = wezterm.font_with_fallback({
	{ family = "VictorMono Nerd Font", weight = "Regular" },
	{ family = "Noto Sans Mono CJK SC", weight = "Regular" },
	"Noto Color Emoji",
})

config.font_size = 11
config.line_height = 0.85
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
config.window_content_alignment = {
	horizontal = "Center",
	vertical = "Center",
}

config.background = {
	{
		source = { Color = "#111111" },
		width = "100%",
		height = "100%",
		opacity = 0.85,
	},
}
local scheme = wezterm.get_builtin_color_schemes()["One Half Black (Gogh)"]
scheme.ansi[1] = "#555555"
scheme.brights[1] = "#555555"
config.color_schemes = { ["One Half Black (Gogh)"] = scheme }
config.color_scheme = "One Half Black (Gogh)"

config.keys = {
	{
		key = "n",
		mods = "SUPER",
		action = wezterm.action_callback(function(_, pane)
			os.execute("wezterm start --always-new-process --cwd " .. pane:get_current_working_dir().file_path .. " &")
		end),
	},
	{
		key = "u",
		mods = "CTRL|ALT",
		action = wezterm.action.ScrollByPage(-0.5),
	},
	{
		key = "d",
		mods = "CTRL|ALT",
		action = wezterm.action.ScrollByPage(0.5),
	},
}
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "NONE",
		action = wezterm.action.ScrollByLine(-3),
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "NONE",
		action = wezterm.action.ScrollByLine(3),
	},
}

return config
