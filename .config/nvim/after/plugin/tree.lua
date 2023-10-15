-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
  renderer = {
    add_trailing = true,
    indent_width = 2,
    indent_markers = {
      enable = true,
      inline_arrows = false
    },
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false
      }
    }
  }
})
