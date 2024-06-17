local opts = { noremap = true, silent = true }

-- Map leader
vim.g.mapleader = " "

-- Delete a word backwards
vim.keymap.set("n", "dw", "vb_d")

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- Tab navigation
vim.keymap.set("n", "te", ":tabedit<CR>", opts)
vim.keymap.set("n", "<tab>", ":tabnext<CR>", opts)
vim.keymap.set("n", "<s-tab>", ":tabprev<CR>", opts)

-- Split window
vim.keymap.set("n", "sv", ":vsplit<CR>", opts)
vim.keymap.set("n", "ss", ":split<CR>", opts)

-- Move window
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")

-- Resize window
vim.keymap.set("n", "<C-w><left>", "<C-w><")
vim.keymap.set("n", "<C-w><right>", "<C-w>>")
vim.keymap.set("n", "<C-w><up>", "<C-w>+")
vim.keymap.set("n", "<C-w><down>", "<C-w>-")

-- Text refactor
vim.keymap.set("n", "<C-f>", ":%s/")
