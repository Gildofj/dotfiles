vim.uv = vim.uv or vim.loop

---@class gildofj.core
---@field icons gildofj.core.icons
local M = {}
M.icons = require("gildofj.core.icons")
_G.Core = M

_G.Utils = require("gildofj.utils")
require("gildofj.core.keymaps")
require("gildofj.core.options")
