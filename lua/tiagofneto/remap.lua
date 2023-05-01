vim.g.mapleader = " "

-- navigate between splits
vim.keymap.set('n', 'vv', '<C-w>v')
vim.keymap.set('n', 'vs', '<C-w>s')

-- tree
vim.keymap.set("n", "<leader>t", vim.cmd.NvimTreeToggle)
