require("nvim-tree").setup({
  sort_by = "case_sensitive",
  open_on_setup = true,
  view = {
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
  diagnostics = {
    enable = true,
  }
})
