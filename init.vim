set nu rnu " absolute number in current line and relative number in the others
set tabstop=2 " how many spaces per tab
set shiftwidth=2 " how many columns per indent level
set expandtab " convert tabs to spaces
set ignorecase " ignore case when searching
set smartcase " if searching with upper case characters don't ignore case
set nobackup " backup before overwriting
set nowritebackup " backup while writing
set noswapfile " no swap files
set nohlsearch " no highlight search
set noerrorbells " no beeps or screen flashes
set autoindent " auto indents
set smartindent " uses the context to indent
set nowrap " doesn't wrap long lines to multiple lines
set incsearch " searches while writing
set termguicolors " requried for some plugins
set scrolloff=8 " start scrolling above the last line
set splitbelow " more natural splits
set splitright
set mouse=a " mouse support
filetype plugin indent on " required for some plugins

call plug#begin()
" Core
Plug 'morhetz/gruvbox' " gruvbox theme
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " treesitter syntax highlighting
Plug 'neovim/nvim-lspconfig' " lspconfig language servers
Plug 'hrsh7th/cmp-nvim-lsp' " cmp auto complete
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'nvim-lua/plenary.nvim' " dependency for various plugins
Plug 'nvim-telescope/telescope.nvim' " telescope fuzze finder
Plug 'nvim-lualine/lualine.nvim' " lualine
Plug 'kyazdani42/nvim-web-devicons' " file icons
Plug 'kyazdani42/nvim-tree.lua' " tree explorer

" Misc
Plug 'tpope/vim-fugitive' " git
Plug 'tpope/vim-surround' " brackets, parentheses, etc...
Plug 'mhinz/vim-signify' " git status line
Plug 'jiangmiao/auto-pairs' " auto closing brackets, parentheses, etc...
Plug 'alvan/vim-closetag' " auto close tag
Plug 'scrooloose/nerdcommenter' " comments
Plug 'norcalli/nvim-colorizer.lua' " colorizer
Plug 'dkarter/bullets.vim' " auto bullets
Plug 'wellle/context.vim' " current context of cursor
call plug#end()

let mapleader=" "

" colorscheme
colorscheme gruvbox
set background=dark

" navigate between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" nvim-cmp
set completeopt=menu,menuone,noselect

" signify
let g:signify_sign_add = '│'
let g:signify_sign_delete = '│'
let g:signify_sign_change = '│'

" telescope
nnoremap <leader><leader> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" tree
nnoremap <leader>t <cmd>NvimTreeFindFileToggle<CR>

lua << EOF
require('treesitter-config')
require('lspconfig-config')
require('diagnostics')
require('nvim-cmp-config')
require('lualine-config')
require('nvim-tree-config')
require('nvim-colorizer-config')
EOF
