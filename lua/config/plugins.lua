vim.pack.add({
    "https://github.com/navarasu/onedark.nvim",
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/stevearc/oil.nvim"
})

vim.cmd.colorscheme("onedark")

require "mini.pick".setup()
require "mini.icons".setup()
require "mason".setup()
require "oil".setup()
require "gitsigns".setup()
