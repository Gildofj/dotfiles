local opts = { noremap = true, silent = true }

-- Delete a word backwards
vim.keymap.set("n", "dw", "vb_d")

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- Split window
vim.keymap.set("n", "sv", ":vsplit<CR>", opts)
vim.keymap.set("n", "ss", ":split<CR>", opts)
vim.keymap.set("n", "sc", ":q<CR>", opts)

-- Resize window
vim.keymap.set("n", "<C-w><left>", "<C-w><")
vim.keymap.set("n", "<C-w><right>", "<C-w>>")
vim.keymap.set("n", "<C-w><up>", "<C-w>+")
vim.keymap.set("n", "<C-w><down>", "<C-w>-")

-- Text refactor
vim.keymap.set("n", "<C-f>", ":%s/")
