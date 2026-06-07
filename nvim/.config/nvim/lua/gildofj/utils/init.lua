---@class gildofj.utils
---@field root gildofj.utils.root
---@field lualine gildofj.utils.lualine
---@field lsp gildofj.utils.lsp
---@field treesitter gildofj.utils.treesitter
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("gildofj.utils." .. k)
    return t[k]
  end,
})

---@param val any
M.inspect = function(val)
  return vim.inspect(val)
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param group string|string[] hl group to get color from
---@param prop? string property to get. Defaults to "fg"
function M.color(group, prop)
  prop = prop or "fg"
  group = type(group) == "table" and group or { group }
  --@cast group string[]
  for _, g in ipairs(group) do
    local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
    if hl[prop] then
      return string.format("#%06x", hl[prop])
    end
  end
end

---@param path string
function M.norm(path)
  return vim.fn.fnamemodify(vim.fn.expand(path), ":p")
end

M.is_dir = function(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "directory"
end

M.open = function(path)
  path = M.norm(path)
  if vim.fn.has("win32") == 1 then
    vim.fn.system({ "start", path })
  elseif vim.fn.has("macunix") == 1 then
    vim.fn.system({ "open", path })
  else
    vim.fn.system({ "xdg-open", path })
  end
end

---@class InfoParams
---@field title? string
---@field timeout? number

---@param lines string|string[]
---@param opts? InfoParams
M.info = function(lines, opts)
  opts = opts or {}
  local msg = type(lines) == "table" and table.concat(lines, "\n") or lines
  vim.notify(msg, vim.log.levels.INFO, {
    title = opts.title or "Info",
    timeout = opts.timeout or 3000,
  })
end

---@param lines string|string[]
---@param opts? InfoParams
M.warn = function(lines, opts)
  opts = opts or {}
  local msg = type(lines) == "table" and table.concat(lines, "\n") or lines
  vim.notify(msg, vim.log.levels.WARN, {
    title = opts.title or "Warning",
    timeout = opts.timeout or 3000,
  })
end

---@param lines string|string[]
---@param opts? InfoParams
M.error = function(lines, opts)
  opts = opts or {}
  local msg = type(lines) == "table" and table.concat(lines, "\n") or lines
  vim.notify(msg, vim.log.levels.ERROR, {
    title = opts.title or "Error",
    timeout = opts.timeout or 3000,
  })
end

-- Determina se é seguro definir uma opção para um valor padrão.
function M.set_default(option, value)
  local l = vim.api.nvim_get_option_value(option, { scope = "local" })
  local g = vim.api.nvim_get_option_value(option, { scope = "global" })
  if l == g then
    vim.api.nvim_set_option_value(option, value, { scope = "local" })
    return true
  end
  return false
end

return M
