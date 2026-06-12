local M = {}

local config_file = vim.fs.joinpath(vim.fn.stdpath("data"), "theme_config.json")
local old_theme_file = vim.fs.joinpath(vim.fn.stdpath("data"), "last_theme.txt")

M.config = {
  follow_system = false,
  dark_theme = "catppuccin",
  light_theme = "tokyonight-day",
  manual_theme = "catppuccin",
}

M.is_syncing = false
local sync_timer = nil

function M.load_config()
  local f = io.open(config_file, "r")
  if f then
    local content = f:read("*all")
    f:close()
    local ok, parsed = pcall(vim.json.decode, content)
    if ok and type(parsed) == "table" then
      M.config = vim.tbl_deep_extend("force", M.config, parsed)
      return
    end
  end

  local old_f = io.open(old_theme_file, "r")
  if old_f then
    local old_theme = old_f:read("*all"):gsub("%s+", "")
    old_f:close()
    if old_theme ~= "" then
      M.config.manual_theme = old_theme
      M.config.dark_theme = old_theme
    end
    M.save_config()
  end
end

function M.save_config()
  local f = io.open(config_file, "w")
  if f then
    f:write(vim.json.encode(M.config))
    f:close()
  end
end

function M.detect_system_mode(callback)
  local os_name = vim.uv.os_uname().sysname

  if os_name == "Darwin" then
    if callback then
      vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }, function(obj)
        local is_dark = obj.code == 0 and obj.stdout and obj.stdout:gsub("%s+", "") == "Dark"
        callback(is_dark and "dark" or "light")
      end)
    else
      local res = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
      return res:gsub("%s+", "") == "Dark" and "dark" or "light"
    end
  elseif os_name:match("Windows") or os_name == "Windows_NT" then
    if callback then
      vim.system({ "powershell", "-NoProfile", "-Command", "Get-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize' -Name AppsUseLightTheme | Select-Object -ExpandProperty AppsUseLightTheme" }, { text = true }, function(obj)
        local is_light = obj.code == 0 and obj.stdout and obj.stdout:gsub("%s+", ""):match("1") ~= nil
        callback(is_light and "light" or "dark")
      end)
    else
      local cmd = 'reg query "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" /v AppsUseLightTheme 2>nul'
      local res = vim.fn.system(cmd)
      return res:match("REG_DWORD%s+0x0") and "dark" or "light"
    end
  elseif os_name == "Linux" then
    if callback then
      vim.system({ "dbus-send", "--print-reply=literal", "--dest=org.freedesktop.portal.Desktop", "/org/freedesktop/portal/desktop", "org.freedesktop.portal.Settings.Read", "string:org.freedesktop.appearance", "string:color-scheme" }, { text = true }, function(obj)
        local is_dark = false
        if obj.code == 0 and obj.stdout then
          is_dark = obj.stdout:match("uint32%s+1") ~= nil or obj.stdout:match("1") ~= nil
        else
          local g_res = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
          is_dark = g_res:match("prefer%-dark") ~= nil
        end
        callback(is_dark and "dark" or "light")
      end)
    else
      local res = vim.fn.system("dbus-send --print-reply=literal --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' 2>/dev/null")
      if res:match("uint32%s+1") or res:match("1") then
        return "dark"
      end
      res = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
      return res:match("prefer%-dark") and "dark" or "light"
    end
  else
    if callback then callback("dark") else return "dark" end
  end
end

function M.apply_system_theme(mode)
  local target_theme = mode == "dark" and M.config.dark_theme or M.config.light_theme
  if vim.g.colors_name ~= target_theme then
    M.is_syncing = true
    local ok, _ = pcall(vim.cmd.colorscheme, target_theme)
    M.is_syncing = false
    if ok then
      vim.o.background = mode
    end
  end
end

function M.start_sync_timer()
  M.stop_sync_timer()
  if not M.config.follow_system then
    return
  end

  sync_timer = vim.uv.new_timer()
  sync_timer:start(3000, 3000, vim.schedule_wrap(function()
    if not M.config.follow_system then
      M.stop_sync_timer()
      return
    end

    M.detect_system_mode(vim.schedule_wrap(function(mode)
      M.apply_system_theme(mode)
    end))
  end))
end

function M.stop_sync_timer()
  if sync_timer then
    pcall(function()
      sync_timer:stop()
      sync_timer:close()
    end)
    sync_timer = nil
  end
end

function M.save(theme)
  if M.is_syncing then
    return
  end

  if M.config.follow_system then
    local mode = M.detect_system_mode()
    if mode == "dark" then
      M.config.dark_theme = theme
    else
      M.config.light_theme = theme
    end
  else
    M.config.manual_theme = theme
  end
  M.save_config()
end

function M.load()
  M.load_config()

  if M.config.follow_system then
    local mode = M.detect_system_mode()
    M.apply_system_theme(mode)
    M.start_sync_timer()
  else
    M.is_syncing = true
    local ok, _ = pcall(vim.cmd.colorscheme, M.config.manual_theme)
    M.is_syncing = false
    if not ok then
      pcall(vim.cmd.colorscheme, "catppuccin")
    end
  end
end

function M.select_colorscheme(prompt, on_select)
  local colors = vim.fn.getcompletion("", "color")
  table.sort(colors)
  vim.ui.select(colors, {
    prompt = prompt,
  }, function(choice)
    if choice then
      on_select(choice)
    end
  end)
end

function M.open_menu()
  M.load_config()

  local status_system = M.config.follow_system and "󰄲 Ativo" or "󰄱 Inativo"
  local options = {
    string.format("󰖨  Seguir Tema do Sistema: [%s]", status_system),
    string.format("󰖔  Tema Escuro Padrão: %s", M.config.dark_theme),
    string.format("󰆲  Tema Claro Padrão: %s", M.config.light_theme),
    "🎨 Selecionar Tema Manualmente...",
  }

  vim.ui.select(options, {
    prompt = "⚙️  Configurações de Tema",
  }, function(choice)
    if not choice then
      return
    end

    if choice:match("Seguir Tema do Sistema") then
      M.config.follow_system = not M.config.follow_system
      M.save_config()
      if M.config.follow_system then
        M.apply_system_theme(M.detect_system_mode())
        M.start_sync_timer()
        vim.notify("Sincronização com o tema do sistema: ATIVADA", vim.log.levels.INFO)
      else
        M.stop_sync_timer()
        M.is_syncing = true
        pcall(vim.cmd.colorscheme, M.config.manual_theme)
        M.is_syncing = false
        vim.notify("Sincronização com o tema do sistema: DESATIVADA", vim.log.levels.INFO)
      end
      vim.schedule(M.open_menu)

    elseif choice:match("Tema Escuro Padrão") then
      M.select_colorscheme("󰖔  Selecione o Tema Escuro Padrão", function(theme)
        M.config.dark_theme = theme
        M.save_config()
        if M.config.follow_system and M.detect_system_mode() == "dark" then
          M.apply_system_theme("dark")
        end
        vim.notify("Tema escuro padrão alterado para: " .. theme, vim.log.levels.INFO)
        vim.schedule(M.open_menu)
      end)

    elseif choice:match("Tema Claro Padrão") then
      M.select_colorscheme("󰆲  Selecione o Tema Claro Padrão", function(theme)
        M.config.light_theme = theme
        M.save_config()
        if M.config.follow_system and M.detect_system_mode() == "light" then
          M.apply_system_theme("light")
        end
        vim.notify("Tema claro padrão alterado para: " .. theme, vim.log.levels.INFO)
        vim.schedule(M.open_menu)
      end)

    elseif choice:match("Selecionar Tema Manualmente") then
      M.select_colorscheme("🎨 Selecione o Tema Manual", function(theme)
        M.config.follow_system = false
        M.config.manual_theme = theme
        M.save_config()
        M.stop_sync_timer()
        M.is_syncing = true
        local ok, _ = pcall(vim.cmd.colorscheme, theme)
        M.is_syncing = false
        if ok then
          vim.notify("Tema manual definido para: " .. theme, vim.log.levels.INFO)
        else
          vim.notify("Falha ao carregar o tema: " .. theme, vim.log.levels.ERROR)
        end
      end)
    end
  end)
end

function M.toggle_background()
  M.load_config()
  local current_bg = vim.o.background
  local target_mode = current_bg == "dark" and "light" or "dark"
  local target_theme = target_mode == "dark" and M.config.dark_theme or M.config.light_theme

  local was_following = M.config.follow_system
  if was_following then
    M.config.follow_system = false
    M.stop_sync_timer()
  end

  M.config.manual_theme = target_theme
  M.save_config()

  M.is_syncing = true
  local ok, _ = pcall(vim.cmd.colorscheme, target_theme)
  M.is_syncing = false

  if ok then
    vim.o.background = target_mode
    local msg = string.format("Background set to %s (Theme: %s)", target_mode, target_theme)
    if was_following then
      msg = msg .. " [Sincronização desativada]"
    end
    vim.notify(msg, vim.log.levels.INFO, { title = "Appearance" })
  else
    vim.notify("Falha ao carregar o tema: " .. target_theme, vim.log.levels.ERROR)
  end
end

return M
