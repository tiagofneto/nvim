return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.3",
            build = "make install_jsregexp"
        },
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "rafamadriz/friendly-snippets",
        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            config = true
        }
    },
    config = function()
        local cmp = require('cmp')

        require("fidget").setup({})

        local cmp_autopairs = require('nvim-autopairs.completion.cmp')

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered()
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = "nvim_lsp_signature_help" },
                { name = "nvim_lua" },
                { name = 'luasnip' },
                { name = 'path' },
            }, {
                { name = 'buffer' }
            }),
            formatting = {
                fields = {'menu', 'abbr', 'kind'},

                format = function(entry, item)
                    local menu_icon = {
                        nvim_lsp = 'λ',
                        luasnip = '⋗',
                        buffer = 'Ω',
                        path = '',
                        nvim_lua = 'Π',
                    }

                    local kind_icons = {
                        Text = "",
                        Method = "",
                        Function = "",
                        Constructor = "",
                        Field = "",
                        Variable = "",
                        Class = "ﴯ",
                        Interface = "",
                        Module = "",
                        Property = "ﰠ",
                        Unit = "",
                        Value = "",
                        Enum = "",
                        Keyword = "",
                        Snippet = "",
                        Color = "",
                        File = "",
                        Reference = "",
                        Folder = "",
                        EnumMember = "",
                        Constant = "",
                        Struct = "",
                        Event = "",
                        Operator = "",
                        TypeParameter = ""
                    }

                    item.menu = menu_icon[entry.source.name]
                    item.kind = string.format('%s %s', kind_icons[item.kind], item.kind)
                    return item
                end
            }
        })

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })

        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end
}

