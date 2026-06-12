local opts = { noremap = true, silent = true }

-- Toggle background
vim.keymap.set("n", "<leader>ub", function()
  local theme = require("gildofj.core.theme")
  theme.toggle_background()
end, { desc = "Toggle Background (Dark/Light)" })
