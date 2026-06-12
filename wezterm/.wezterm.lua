local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28

config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"Fira Code",
	"JetBrains Mono",
})
config.font_size = 12

-- Detecta a aparência do sistema de forma segura (evitando erros no servidor multiplexer)
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

-- Retorna o tema apropriado para a aparência detectada
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())

config.window_close_confirmation = "NeverPrompt"

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

return config
