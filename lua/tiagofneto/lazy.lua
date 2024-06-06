local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
    {
        'navarasu/onedark.nvim',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme onedark]])
        end,
    },
	{
		'nvim-treesitter/nvim-treesitter',
		build = ":TSUpdate"
	},
	'nvim-treesitter/playground',
	'nvim-tree/nvim-tree.lua',
	'nvim-tree/nvim-web-devicons',
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
			'williamboman/mason.nvim',
			build = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		},
		{'williamboman/mason-lspconfig.nvim'}, -- Optional

		-- Autocompletion
		{'hrsh7th/nvim-cmp'},     -- Required
		{'hrsh7th/cmp-nvim-lsp'}, -- Required
		{'L3MON4D3/LuaSnip'},     -- Required
	}
},
	'christoomey/vim-tmux-navigator',
	'nvim-lualine/lualine.nvim',
    'tpope/vim-fugitive',
    'tpope/vim-surround',
    'airblade/vim-gitgutter',
    'windwp/nvim-autopairs',
    'preservim/nerdcommenter',
    'norcalli/nvim-colorizer.lua',
    'dkarter/bullets.vim',
    'wellle/context.vim',
    'github/copilot.vim',
    '0xhyoga/starknet-vim',
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = "make"
    },
    'simrat39/rust-tools.nvim',
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    }
}

local opts = {}

require("lazy").setup(plugins, opts)
