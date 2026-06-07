vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true

local map = require("config.cheatsheet").map
map('n', 'j', 'gj', { buffer = true, desc = 'Down (display line)' })
map('n', 'k', 'gk', { buffer = true, desc = 'Up (display line)' })
map('n', '<leader>c', '1z=', { buffer = true, desc = 'Fix spelling (first suggestion)' })
