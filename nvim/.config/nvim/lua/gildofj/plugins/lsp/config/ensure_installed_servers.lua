---@type string[]
local M = { "lua_ls", "vtsls", "cssmodules_ls", "emmet_ls", "html", "jsonls", "tailwindcss", "astro" }

if Utils.is_win() then
  table.insert(M, "powershell_es")
end

return M
