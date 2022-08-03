require("bufferline").setup{
  options = {
    mode = "tabs",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
}
require("scope").setup()
