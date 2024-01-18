-- Pull in the wezterm API
local wezterm = require("wezterm")

-- https://wezfurlong.org/wezterm/config/lua/gui-events/gui-startup.html
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(string.format("%s [%s]", window:active_workspace(), pane:get_domain_name()))
end)

wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local title = string.format(" %s: %s ", tab.tab_index + 1, basename(pane.current_working_dir))

	-- local color = "navy"
	-- if tab.is_active then
	-- 	color = "blue"
	-- end
	-- return {
	-- 	{ Background = { Color = color } },
	-- 	{ Text = " " .. title .. " " },
	-- }
	return title
end)

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.color_scheme = "nordfox"
config.font = wezterm.font({
	family = "JetBrainsMono Nerd Font",
	-- disable ligatures
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.line_height = 1.3

local act = wezterm.action
config.keys = {
	{
		key = ",",
		mods = "CMD",
		action = act.SpawnCommandInNewTab({
			cwd = os.getenv("WEZTERM_CONFIG_DIR"),
			set_environment_variables = {
				TERM = "screen-256color",
			},
			args = {
				"/opt/homebrew/bin/nvim",
				os.getenv("WEZTERM_CONFIG_FILE"),
			},
		}),
	},
	-- other keys
	{ key = "l", mods = "CTRL", action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "h", mods = "CTRL", action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "k", mods = "CTRL", action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "j", mods = "CTRL", action = act({ ActivatePaneDirection = "Down" }) },
	-- Clears the scrollback and viewport, and then sends CTRL-L to ask the
	-- shell to redraw its prompt
	{
		key = "K",
		mods = "CTRL|SHIFT",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
}

-- and finally, return the configuration to wezterm
return config
