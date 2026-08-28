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

-- The mutter title bar is the only always-visible header: the tab bar sits at
-- the bottom and hides itself when there is a single tab. So the domain name
-- ("local", or an ssh_domains name like "gdev2") goes here.
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	return string.format("%s \u{2014} %s", pane.domain_name, pane.title)
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
	-- current_working_dir is a Url object (since 20240127), not a string, and is
	-- nil until the shell emits OSC 7.
	local cwd = pane.current_working_dir
	local dir = cwd and (cwd.file_path or cwd.path) or ""
	local title = string.format(" %s: %s ", tab.tab_index + 1, basename(dir))

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
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages. This must come BEFORE any
-- config.* assignment, since it replaces the table wholesale.
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font("JetBrains Mono")
config.warn_about_missing_glyphs = false

-- This is where you actually apply your config choices

-- GNOME/mutter provides no server-side decorations on Wayland, and wezterm's
-- Wayland backend is mid-reimplementation upstream, so the title bar vanishes
-- and the window can't be dragged. XWayland gets a real mutter frame
-- (_NET_FRAME_EXTENTS top = 37px); mutter's xwayland-native-scaling keeps it sharp.
config.enable_wayland = false

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

-- Remote dev box. Address/user/key come from ~/.ssh/config `Host gdev2`.
-- multiplexing = "WezTerm" spawns wezterm-mux-server on gdev2, so panes
-- survive client restarts and network drops.
config.ssh_domains = {
	{
		name = "gdev2",
		remote_address = "gdev2",
		username = "gaonknic44",
		multiplexing = "WezTerm",
		assume_shell = "Posix",
	},
}

-- CTRL+SHIFT+G: open a new tab on gdev2
table.insert(config.keys, {
	key = "g",
	mods = "CTRL|SHIFT",
	action = act.SpawnCommandInNewTab({ domain = { DomainName = "gdev2" } }),
})

-- and finally, return the configuration to wezterm
return config
