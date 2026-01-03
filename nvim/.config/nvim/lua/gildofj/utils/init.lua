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

---@param val string
M.inspect = function(val)
  return vim.inpect(val)
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

M.root_dir = function()
  local cwd = vim.uv.cwd()
  local root = vim.fs.find({ ".git" }, { upward = true, path = cwd })[1]
  return root and vim.fs.dirname(root) or cwd
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

---@param lines string[]
---@param opts InfoParams
M.info = function(lines, opts)
  opts = opts or {}
  local msg = table.concat(lines, "\n")
  vim.notify(msg, vim.log.levels.INFO, {
    title = opts.title or "Info",
    timeout = opts.timeout or 3000,
  })
end

---@param lines string[]
---@param opts InfoParams
M.warn = function(lines, opts)
  opts = opts or {}
  local msg = table.concat(lines, "\n")
  vim.notify(msg, vim.log.levels.WARN, {
    title = opts.title or "Info",
    timeout = opts.timeout or 3000,
  })
end

---@param lines string[]
---@param opts InfoParams
M.error = function(lines, opts)
  opts = opts or {}
  local msg = table.concat(lines, "\n")
  vim.notify(msg, vim.log.levels.ERROR, {
    title = opts.title or "Info",
    timeout = opts.timeout or 3000,
  })
end

local _defaults = {} ---@type table<string, boolean>

-- Determines whether it's safe to set an option to a default value.
--
-- It will only set the option if:
-- * it is the same as the global value
-- * it's current value is a default value
-- * it was last set by a script in $VIMRUNTIME
---@param option string
---@param value string|number|boolean
---@return boolean was_set
function M.set_default(option, value)
  local l = vim.api.nvim_get_option_value(option, { scope = "local" })
  local g = vim.api.nvim_get_option_value(option, { scope = "global" })

  _defaults[("%s=%s"):format(option, value)] = true
  local key = ("%s=%s"):format(option, l)

  local source = ""
  if l ~= g and not _defaults[key] then
    -- Option does not match global and is not a default value
    -- Check if it was set by a script in $VIMRUNTIME
    local info = vim.api.nvim_get_option_info2(option, { scope = "local" })
    ---@param e vim.fn.getscriptinfo.ret
    local scriptinfo = vim.tbl_filter(function(e)
      return e.sid == info.last_set_sid
    end, vim.fn.getscriptinfo())
    source = scriptinfo[1] and scriptinfo[1].name or ""
    local by_rtp = #scriptinfo == 1 and vim.startswith(scriptinfo[1].name, vim.fn.expand("$VIMRUNTIME"))
    if not by_rtp then
      return false
    end
  end

  vim.api.nvim_set_option_value(option, value, { scope = "local" })
  return true
end

return M
