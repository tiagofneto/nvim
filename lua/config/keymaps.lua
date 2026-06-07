local map = require("config.cheatsheet").map

map('n', '<leader>x', '<cmd>source %<CR>', { desc = 'Source current file' })
map('v', '<leader>x', '<cmd>lua<CR>', { desc = 'Execute selection as Lua' })

-- Auto pair completions
vim.keymap.set('i', '(', '()<Left>')
vim.keymap.set('i', '[', '[]<Left>')
vim.keymap.set('i', '{', '{}<Left>')
vim.keymap.set('i', '"', '""<Left>')
vim.keymap.set('i', "'", "''<Left>")

map('n', '<leader><leader>', '<cmd>Pick files<CR>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'Live grep' })
map('n', '<leader>h', '<cmd>Pick help<CR>', { desc = 'Help tags' })

map('n', '<leader>t', '<cmd>Oil --float<CR>', { desc = 'File explorer (Oil)' })
