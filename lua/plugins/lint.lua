return {
    'mfussenegger/nvim-lint',
    config = function()
        require('lint').linters_by_ft = {
            lua = { 'luacheck' },
            javascript = { 'eslint' },
            typescript = { 'eslint' },
            rust = { 'clippy' },
        }

        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
            callback = function()
                require('lint').try_lint()

                -- You can call `try_lint` with a linter name or a list of names to always
                -- run specific linters, independent of the `linters_by_ft` configuration
                -- require('lint').try_lint('cspell')
            end,
        })
    end,
}
