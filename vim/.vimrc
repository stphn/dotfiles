" ========================================
" Vanilla Vim Configuration - Omarchy Themed
" ========================================
" Omarchy Philosophy: A beautiful system is a motivating system.
" This configuration emphasizes cohesive theming, TUI aesthetics,
" and keyboard-driven productivity.
"
" Theme Switching: Set VIM_THEME environment variable
" Example: export VIM_THEME=nord (gruvbox, nord, tokyonight, catppuccin, everforest)
"
" ========================================
" Options
" ========================================
set encoding=UTF-8
set spelllang=en_us,de_de,fr_fr
set nohlsearch " Disable highlight on search
set number " Enable line numbers
set mouse=a " Enable mouse mode
set breakindent " Enable break indent
set undofile " Save undo history
set ignorecase " Case-insensitive searching unless \C or capital in search
set smartcase " Enable smart case
set signcolumn=yes " Keep signcolumn on by default
set updatetime=250 " Decrease update time
set timeoutlen=300 " Time to wait for a mapped sequence to complete (in milliseconds)
set nobackup " Don't create a backup file
set nowritebackup " Don't write backup before overwriting
set completeopt=menuone,noselect " Better completion experience
set whichwrap+=<,>,[,],h,l " Allow certain keys to move to the next line
set nowrap " Display long lines as one line
set linebreak " Don't break words when wrapping
set scrolloff=8 " Keep 8 lines above/below cursor
set sidescrolloff=8 " Keep 8 columns to the left/right of cursor
set relativenumber " Use relative line numbers
set numberwidth=4 " Number column width
set shiftwidth=4 " Spaces per indentation
set tabstop=4 " Spaces per tab
set softtabstop=4 " Spaces per tab during editing ops
set expandtab " Convert tabs to spaces
set nocursorline " Don't highlight the current line
set splitbelow " Horizontal splits below current window
set splitright " Vertical splits to the right
set noswapfile " Don't use a swap file
set smartindent " Smart indentation
set showtabline=2 " Always show tab line
set backspace=indent,eol,start " Configurable backspace behavior
set pumheight=10 " Popup menu height
set conceallevel=0 " Make `` visible in markdown
set fileencoding=utf-8 " File encoding
set cmdheight=1 " Command line height
set autoindent " Auto-indent new lines
set shortmess+=c " Don't show completion menu messages
set iskeyword+=- " Treat hyphenated words as whole words
set showmatch " show the matching part of pairs [] {} and ()
set laststatus=2 " Show status bar

" Minimalist statusline (omarchy TUI aesthetic)
set statusline=
set statusline+=\ %f " Path to the file
set statusline+=%m " Modified flag
set statusline+=%r " Readonly flag
set statusline+=%= " Switch to the right side
set statusline+=%y " File type
set statusline+=\ %l:%c " Line:Column
set statusline+=\ %p%% " Percentage through file
set statusline+=\


" ========================================
" Keymaps
" ========================================

" Set leader key
let mapleader = " "
let maplocalleader = " "

" Disable the spacebar key's default behavior in Normal and Visual modes
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

" Allow moving the cursor through wrapped lines with j, k
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" clear highlights
nnoremap <Esc> :noh<CR>

" save file
nnoremap <C-s> :w<CR>

" save file without auto-formatting
nnoremap <leader>sn :noautocmd w<CR>

" quit file
nnoremap <C-q> :q<CR>

" delete single character without copying into register
nnoremap x "_x

" Vertical scroll and center
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Find and center
nnoremap n nzzzv
nnoremap N Nzzzv

" Resize with arrows (Shift + arrow keys)
nnoremap <S-Up> :resize -2<CR>
nnoremap <S-Down> :resize +2<CR>
nnoremap <S-Left> :vertical resize -2<CR>
nnoremap <S-Right> :vertical resize +2<CR>

" Navigate buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <leader>sb :buffers<CR>:buffer<Space>

" increment/decrement numbers
nnoremap <leader>+ <C-a>
nnoremap <leader>- <C-x>

" window management
nnoremap <leader>v <C-w>v
nnoremap <leader>h <C-w>s
nnoremap <leader>se <C-w>=
nnoremap <leader>xs :close<CR>

" Navigate between splits
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>

" tabs
nnoremap <leader>to :tabnew<CR>
nnoremap <leader>tx :tabclose<CR>
nnoremap <leader>tn :tabn<CR>
nnoremap <leader>tp :tabp<CR>

nnoremap <leader>x :bdelete<CR>
nnoremap <leader>b :enew<CR>

" toggle line wrapping
nnoremap <leader>lw :set wrap!<CR>

" Press jk fast to exit insert mode
inoremap jk <ESC>
inoremap kj <ESC>

" Stay in indent mode
" vnoremap < <gv
" vnoremap > >gv

" Keep last yanked when pasting
vnoremap p "_dP

" Explicitly yank to system clipboard (highlighted and entire row)
noremap <leader>y "+y
noremap <leader>Y "+Y

" Open file explorer
noremap <silent> <leader>e :Lex<CR>


" ========================================
" Other
" ========================================

" ========================================
" Omarchy Theming
" ========================================
" Philosophy: A beautiful system is a motivating system.
" Omarchy emphasizes cohesive theming across all tools for productivity.
" Supported themes: gruvbox, nord, tokyonight, catppuccin, everforest
" Set VIM_THEME environment variable to override (e.g., export VIM_THEME=gruvbox)

" Syntax highlighting
syntax on

" Get theme from environment variable or use default
let s:vim_theme = $VIM_THEME != '' ? $VIM_THEME : 'gruvbox'

" Set background before loading colorscheme
set background=dark

" Apply theme based on availability
" Fallback to built-in schemes if plugin themes not available
if s:vim_theme == 'gruvbox'
    silent! colorscheme gruvbox
    if !exists('g:colors_name') || g:colors_name != 'gruvbox'
        colorscheme desert
    endif
elseif s:vim_theme == 'nord'
    silent! colorscheme nord
    if !exists('g:colors_name') || g:colors_name != 'nord'
        colorscheme slate
    endif
elseif s:vim_theme == 'tokyonight'
    silent! colorscheme tokyonight-night
    if !exists('g:colors_name') || !match(g:colors_name, 'tokyonight')
        colorscheme evening
    endif
elseif s:vim_theme == 'catppuccin'
    silent! colorscheme catppuccin-mocha
    if !exists('g:colors_name') || !match(g:colors_name, 'catppuccin')
        colorscheme darkblue
    endif
elseif s:vim_theme == 'everforest'
    silent! colorscheme everforest
    if !exists('g:colors_name') || g:colors_name != 'everforest'
        colorscheme wildcharm
    endif
else
    " Default to wildcharm if unknown theme
    colorscheme wildcharm
endif

" Minimalist TUI aesthetic: clean background for terminal transparency
hi Normal ctermbg=NONE guibg=NONE
hi NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE
hi VertSplit guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi EndOfBuffer ctermbg=NONE guibg=NONE
hi LineNr ctermbg=NONE guibg=NONE
hi CursorLineNr ctermbg=NONE guibg=NONE
hi Pmenu ctermbg=NONE guibg=NONE
hi PmenuSel ctermbg=NONE guibg=NONE
hi Folded ctermbg=NONE guibg=NONE

" Sync clipboard with OS
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif

" True colors
if !has('gui_running') && &term =~ '\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

" Use a line cursor within insert mode and a block cursor everywhere else.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25 
" Use 'l' instead of <CR> to open files
augroup netrw_setup | au!
    au FileType netrw nmap <buffer> l <CR>
augroup END

