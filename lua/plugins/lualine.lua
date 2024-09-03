return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local mode_map = {
            ['NORMAL'] = '일반',
            ['O-PENDING'] = 'O-대기',
            ['INSERT'] = '삽입',
            ['VISUAL'] = '시각',
            ['V-BLOCK'] = 'V-블록',
            ['V-LINE'] = 'V-라인',
            ['V-REPLACE'] = 'V-대체',
            ['REPLACE'] = '대체',
            ['COMMAND'] = '명령',
            ['SHELL'] = '쉘',
            ['TERMINAL'] = '터미널',
            ['EX'] = 'EX',
            ['S-BLOCK'] = 'S-블록',
            ['S-LINE'] = 'S-라인',
            ['SELECT'] = '선택',
            ['CONFIRM'] = '확인?',
            ['MORE'] = '더보기',
        }

        require('lualine').setup({
            options = {
                disabled_filetypes = {
                    statusline = { 'NvimTree' },
                    winbar = { 'NvimTree' },
                },
            },
            sections = {
                lualine_a = {
                    {
                        'mode',
                        separator = { left = '' },
                        right_padding = 2,
                        fmt = function(mode)
                            return mode_map[mode]
                        end,
                    },
                },
                lualine_b = {
                    'branch',
                    'diff',
                    {
                        'diagnostics',
                        symbols = {
                            error = '✘',
                            warn = '',
                            info = '',
                            hint = '•',
                        },
                    },
                },
                lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
            },
        })
    end,
}
