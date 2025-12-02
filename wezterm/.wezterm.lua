local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 288

config.font = wezterm.font("Jetbrains Mono")
config.font_size = 12
config.color_scheme = "Catppuccin Mocha"

config.exit_behavior = "Hold"

return config
