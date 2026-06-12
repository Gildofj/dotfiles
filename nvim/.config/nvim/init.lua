vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load shared universal vimscript configuration if available
local shared_config = vim.fn.expand("~/.editor_shared.vim")
if vim.fn.filereadable(shared_config) == 1 then
  pcall(vim.cmd, "source " .. shared_config)
end

require("gildofj.core")
require("gildofj")
