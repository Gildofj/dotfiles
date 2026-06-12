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

" 3. LOAD SHARED CONFIGURATION
" Load common options and keymaps shared across all editors.
let s:shared_config = expand('~/.editor_shared.vim')
if filereadable(s:shared_config)
  execute 'source ' . s:shared_config
endif

" 4. VIM-PLUG AUTO-INSTALLATION
let s:plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(s:plug_path)
  echo "Downloading vim-plug for standard Vim..."
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 5. PLUGIN DEFINITION
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

" 6. VIM-SPECIFIC OPTIONS (Not covered by shared core)
syntax on                         " Enable syntax highlighting
filetype plugin indent on         " Enable filetype plugins & indents

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

if has('termguicolors')
  set termguicolors               " True color support
endif
set background=dark               " Prefer dark mode

" Backups, Swap, and Persistent Undo
set noswapfile                    " Disable swap files (matches Neovim options)
set undofile                      " Enable persistent undo (matches Neovim options)
set undolevels=10000              " Keep 10000 undos
set updatetime=200                " Faster response (matches Neovim options)

" Clipboard & Mouse (Fallback rules)
if has('unnamedplus')
  set clipboard=unnamedplus       " Share system clipboard
endif

" 7. VIM-SPECIFIC KEYMAPS
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

" 8. SMART FEATURES & COMFORT UTILITIES
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

" 9. LIGHTLINE PLUGIN CONFIGURATION
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
