-- global settings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.autoformat = true
vim.g.ai_cmp = true

-- root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- general
vim.opt.autowrite = true -- Enable auto write
vim.opt.completeopt = "menu,menuone,noselect"
vim.conceallevel = 2 -- Hide * markup for bold and italic, but no markers with substitutions
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Highlight current cursor line
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.foldtext = ""
vim.opt.formatexpr = "v:lua.vim.lsp.formatexpr()"
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.inccommand = "nosplit" -- Preview incremental substitute
vim.opt.laststatus = 3 -- GLobal statusline
vim.opt.linebreak = true --  Wrap lines at convenient points
vim.opt.list = true -- Show some invisible caracters (tabs...)
vim.opt.pumblend = 15 -- Popup blend
vim.opt.pumheight = 12 -- Maximum number of entries in a popup
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.spelllang = { "en", "pt_br" }
-- vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]] TODO: Verify snacks to see funcionality
vim.opt.termguicolors = true -- True color support
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap
vim.opt.backspace = "indent,eol,start" -- Allow backspace on indent, end of line or insert mode start position
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard as default register
vim.opt.mouse:append("a")
vim.opt.fileformats = { "unix" } -- Force just unix breakline on neovim
vim.opt.swapfile = false -- Turn off swapfile
vim.opt.autoread = true
vim.bo.autoread = true

-- statusline
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.ruler = false -- Disable the default ruler

-- session management
vim.opt.jumpoptions = "view"
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- encoding
vim.scriptencoding = "utf-8"
vim.encoding = "utf-8"
vim.fileencoding = "utf-8"

-- line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.number = true -- Shows absolute line number on cursor line (when relative number is on)

-- search settings
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- If you include mixed case in your search, assumes you want case-sensitive

-- tabs & indentation
vim.opt.shiftround = true -- Round indent
vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line when starting new one
vim.opt.smartindent = true -- Insert indents automatically

-- split windows
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- Put new windows right of current

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
