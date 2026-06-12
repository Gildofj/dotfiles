#!/bin/bash

# Define paths
ALACRITTY_DIR="$HOME/.config/alacritty"
DARK_THEME="$ALACRITTY_DIR/themes/themes/catppuccin_mocha.toml"
LIGHT_THEME="$ALACRITTY_DIR/themes/themes/catppuccin_latte.toml"
ACTIVE_THEME="$ALACRITTY_DIR/active-theme.toml"

# Read macOS appearance setting
STYLE=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

# Garante que o diretório base existe
mkdir -p "$ALACRITTY_DIR"

if [ "$STYLE" = "Dark" ]; then
    if [ -f "$DARK_THEME" ]; then
        cp "$DARK_THEME" "$ACTIVE_THEME"
    else
        # Fallback caso o submódulo não esteja inicializado
        echo "# Catppuccin Mocha Fallback" > "$ACTIVE_THEME"
    fi
else
    if [ -f "$LIGHT_THEME" ]; then
        cp "$LIGHT_THEME" "$ACTIVE_THEME"
    else
        # Fallback caso o submódulo não esteja inicializado
        echo "# Catppuccin Latte Fallback" > "$ACTIVE_THEME"
    fi
fi
