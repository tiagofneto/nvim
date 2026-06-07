vim.keymap.set('n', '<leader>x', '<cmd>source %<CR>')
vim.keymap.set('v', '<leader>x', '<cmd>lua<CR>')

-- Auto pair completions
vim.keymap.set('i', '(', '()<Left>')
vim.keymap.set('i', '[', '[]<Left>')
vim.keymap.set('i', '{', '{}<Left>')
vim.keymap.set('i', '"', '""<Left>')
vim.keymap.set('i', "'", "''<Left>")

vim.keymap.set('n', '<leader><leader>', '<cmd>Pick files<CR>')
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>')
vim.keymap.set('n', '<leader>h', '<cmd>Pick help<CR>')

vim.keymap.set('n', '<leader>t', '<cmd>Oil --float<CR>')
