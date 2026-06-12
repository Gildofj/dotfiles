" ============================================================================
" Gildo FJ's Smart Cross-Platform .vimrc
" Designed to share parity with his custom Neovim setup while protecting it.
" ============================================================================

" 1. NEOVIM PROTECTION
" If running in Neovim, exit immediately. Neovim uses ~/.config/nvim/init.lua.
if has('nvim')
  finish
endif

" 2. COMPATIBILITY & SYSTEM SETTINGS
set nocompatible              " Be iMproved, required for modern features

" 3. VIM-PLUG AUTO-INSTALLATION
let s:plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(s:plug_path)
  echo "Downloading vim-plug for standard Vim..."
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 4. PLUGIN DEFINITION
call plug#begin('~/.vim/plugged')

" Color Scheme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" Essential Utilities
Plug 'itchyny/lightline.vim'     " Highly customizable, light statusline
Plug 'sheerun/vim-polyglot'      " Modern multi-language syntax highlighting
Plug 'jiangmiao/auto-pairs'      " Replicates Neovim autopairs
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'          " Replicates Telescope functionality

call plug#end()

" 5. OPTIONS PARITY (Matches Neovim gildofj/core/options.lua)
syntax on                         " Enable syntax highlighting
filetype plugin indent on         " Enable filetype plugins & indents

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

" General Appearance & Layout
set number                        " Show absolute line number
set relativenumber                " Show relative line numbers (hybrid)
set cursorline                    " Highlight current line
set signcolumn=yes                " Always show sign column
set nowrap                        " Disable line wrapping
set scrolloff=4                   " Keep 4 lines above/below cursor
set sidescrolloff=8               " Keep 8 columns to left/right cursor
if has('termguicolors')
  set termguicolors               " True color support
endif
set background=dark               " Prefer dark mode

" Backups, Swap, and Persistent Undo
set noswapfile                    " Disable swap files (matches Neovim options)
set undofile                      " Enable persistent undo (matches Neovim options)
set undolevels=10000              " Keep 10000 undos
set updatetime=200                " Faster response (matches Neovim options)

" Indentation (Matches 2-space standard)
set shiftwidth=2
set tabstop=2
set expandtab
set autoindent
set smartindent
set shiftround

" Windows and Splits
set splitbelow                    " Split horizontal windows below
set splitright                    " Split vertical windows right

" Search settings
set ignorecase                    " Case-insensitive search
set smartcase                     " Case-sensitive if capital letter is typed
set hlsearch                      " Highlight matches
set incsearch                     " Incremental search showing partial matches

" Clipboard & Mouse
if has('unnamedplus')
  set clipboard=unnamedplus       " Share system clipboard
endif
set mouse=a                       " Enable mouse interaction

" 6. KEYMAP PARITY (Matches Neovim gildofj/core/keymaps.lua)
let mapleader = " "
let maplocalleader = "\\"

" Delete a word backwards (matches 'dw' -> 'vb_d' keymap)
nnoremap dw vb_d

" Select all (matches '<C-a>' -> 'gg<S-v>G' keymap)
nnoremap <C-a> ggVG

" Split window keymaps
nnoremap sv :vsplit<CR>
nnoremap ss :split<CR>
nnoremap sc :q<CR>

" Resize window keymaps
nnoremap <C-w><left> <C-w><
nnoremap <C-w><right> <C-w>>
nnoremap <C-w><up> <C-w>+
nnoremap <C-w><down> <C-w>-

" Text refactor helper
nnoremap <C-f> :%s/

" Toggle background keymap (matches <leader>ub)
nnoremap <leader>ub :call ToggleBackground()<CR>

function! ToggleBackground()
  if &background == 'dark'
    set background=light
  else
    set background=dark
  endif
  echo "Background set to " . &background
endfunction

" 7. SMART FEATURES & COMFORT UTILITIES
" Reopen files at the last cursor position
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" Auto-create parent directory on save if it doesn't exist
autocmd BufWritePre * call s:Mkdir()
function! s:Mkdir()
  let l:dir = expand('<afile>:p:h')
  if !isdirectory(l:dir) && l:dir !~ '^scp://'
    call mkdir(l:dir, 'p')
  endif
endfunction

" 8. LIGHTLINE PLUGIN CONFIGURATION
let g:lightline = {
  \ 'colorscheme': 'catppuccin_mocha',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'GitBranch'
  \ },
  \ }

" Safe Git branch helper
function! GitBranch()
  if exists('*FugitiveHead')
    return FugitiveHead()
  endif
  return ''
endfunction

" Set color scheme after plugins have loaded
silent! colorscheme catppuccin_mocha
