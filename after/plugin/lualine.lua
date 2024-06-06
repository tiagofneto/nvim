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

--local mode_map = {
  --['NORMAL'] = '正常',
  --['O-PENDING'] = 'O-待定',
  --['INSERT'] = '插入',
  --['VISUAL'] = '可视',
  --['V-BLOCK'] = 'V-块',
  --['V-LINE'] = 'V-行',
  --['V-REPLACE'] = 'V-替换',
  --['REPLACE'] = '替换',
  --['COMMAND'] = '命令',
  --['SHELL'] = '壳',
  --['TERMINAL'] = '终端',
  --['EX'] = 'EX',
  --['S-BLOCK'] = 'S-块',
  --['S-LINE'] = 'S-行',
  --['SELECT'] = '选择',
  --['CONFIRM'] = '确认?',
  --['MORE'] = '更多',
--}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    --component_separators = '|',
    --section_separators = { left = '', right = ''},
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'NvimTree' },
      winbar = { 'NvimTree' },
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {{ 'mode', separator = { left = '' }, right_padding = 2, fmt = function(mode) return mode_map[mode] end }},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {{ 'location', separator = { right = '' }, left_padding = 2 }}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
