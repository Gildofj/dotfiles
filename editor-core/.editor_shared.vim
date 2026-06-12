" ============================================================================
" Shared Configuration for vi(m), ideavim, and neovim
" ============================================================================

" General Appearance & Layout
set number                        " Show absolute line number
set relativenumber                " Show relative line numbers (hybrid)
set cursorline                    " Highlight current line
set signcolumn=yes                " Always show sign column
set nowrap                        " Disable line wrapping
set scrolloff=4                   " Keep 4 lines above/below cursor
set sidescrolloff=8               " Keep 8 columns to left/right cursor
set ignorecase                    " Case-insensitive search
set smartcase                     " Case-sensitive if capital letter is typed
set hlsearch                      " Highlight matches
set incsearch                     " Incremental search showing partial matches

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

" Clipboard & Mouse
set mouse=a                       " Enable mouse interaction

" Keymaps
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
