--[[ TODOS
--Replace all :command
--Replace all vim.cmd
--Figure out icons for mini pick
]]
vim.o.number = true
vim.o.relativenumber = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.swapfile = false
vim.o.backup = false

vim.o.scrolloff = 8

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.wrap = false

vim.o.winborder = "rounded"

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>o', ':update<CR> :so<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.pack.add({
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/echasnovski/mini.pick",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim"
})

require "mini.pick".setup()
require "mason".setup()

vim.keymap.set('n', '<leader><leader>', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")

vim.lsp.enable({ "lua_ls" })

vim.cmd("colorscheme onedark")

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/implementation') then
			-- Create a keymap for vim.lsp.buf.implementation ...
		end

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars

			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if not client:supports_method('textDocument/willSaveWaitUntil')
		    and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})
vim.cmd("set completeopt+=noinsert")
