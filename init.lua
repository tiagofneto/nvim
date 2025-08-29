vim.o.number = true
vim.o.relativenumber = true

vim.o.termguicolors = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

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

vim.o.mouse = "a"

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>x', '<cmd>source %<CR>')
vim.keymap.set('v', '<leader>x', '<cmd>lua<CR>')

vim.keymap.set('n', '<leader>t', '<cmd>Explore<CR>')

-- Auto pair completions
vim.keymap.set('i', '(', '()<Left>')
vim.keymap.set('i', '[', '[]<Left>')
vim.keymap.set('i', '{', '{}<Left>')
vim.keymap.set('i', '"', '""<Left>')
vim.keymap.set('i', "'", "''<Left>")

vim.lsp.enable({ "lua_ls", "ts_ls", "copilot" })

vim.pack.add({
    "https://github.com/navarasu/onedark.nvim",
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/lewis6991/gitsigns.nvim"
})

vim.cmd.colorscheme("onedark")

require "mini.pick".setup()
require "mini.icons".setup()
require "mason".setup()

vim.keymap.set('n', '<leader><leader>', '<cmd>Pick files<CR>')
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>')
vim.keymap.set('n', '<leader>h', '<cmd>Pick help<CR>')

vim.diagnostic.config({
    virtual_lines = {
        current_line = true
    }
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('custom.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars

            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

            vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }

            -- Show function signatures in command line while navigating completion menu
        end

        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('custom.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end

        if client:supports_method('textDocument/inlineCompletion') then
            vim.lsp.inline_completion.enable(true)
            local inline_completion_key = '<Tab>'
            vim.keymap.set('i', inline_completion_key, function()
                if not vim.lsp.inline_completion.get() then
                    return inline_completion_key
                end
            end, {
                expr = true,
                replace_keycodes = true,
                desc = 'Get the current inline completion',
            })
        end
    end,
})
