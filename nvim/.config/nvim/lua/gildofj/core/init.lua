vim.uv = vim.uv or vim.loop

---@class Core
---@field icons gildofj.core.icons
---@field options table
local M = {}

-- Metatabela para Lazy Loading dos módulos internos do Core
setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "gildofj.core." .. k)
    if ok then
      rawset(t, k, mod)
      return mod
    end
  end
})

-- Expõe apenas um único ponto de entrada global
_G.Core = M
_G.Utils = require("gildofj.utils")

-- Inicializa o básico
Utils.root.setup()
require("gildofj.core.options")
require("gildofj.core.keymaps")
require("gildofj.core.autocmds")
