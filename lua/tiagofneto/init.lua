require("tiagofneto.remap")
require("tiagofneto.lazy")
require("tiagofneto.set")

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.keymap.set("n", "<leader>t", vim.cmd.NvimTreeToggle)
