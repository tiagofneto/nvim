vim.lsp.enable({ "lua_ls", "ts_ls", "rust_analyzer", "copilot", "ty", "ruff", "terraformls", "gh_actions_ls" })

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
            -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            -- Only A-Z a-z and .
            local chars = {};
            for i = 65, 90 do table.insert(chars, string.char(i)) end
            for i = 97, 122 do table.insert(chars, string.char(i)) end
            table.insert(chars, string.char(46))
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
            require("config.cheatsheet").map('i', inline_completion_key, function()
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
