local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28

config.font = wezterm.font("Jetbrains Mono")
config.font_size = 12
config.color_scheme = "Catppuccin Mocha"

config.window_close_confirmation = "NeverPrompt"

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

return config
