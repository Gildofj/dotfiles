local M = {}

local theme_file = vim.fs.joinpath(vim.fn.stdpath("data"), "last_theme.txt")

function M.save(theme)
  local f = io.open(theme_file, "w")
  if f then
    f:write(theme)
    f:close()
  end
end

function M.load()
  local f = io.open(theme_file, "r")
  if f then
    local theme = f:read("*all"):gsub("%s+", "")
    f:close()
    if theme ~= "" then
      local ok, _ = pcall(vim.cmd.colorscheme, theme)
      if not ok then
        -- Se o tema falhar (ex: plugin removido), volta para um padrão seguro
        pcall(vim.cmd.colorscheme, "catppuccin")
      end
    end
  else
    -- Primeiro boot ou arquivo não existe
    pcall(vim.cmd.colorscheme, "catppuccin")
  end
end

return M
