return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c_sharp",
        "lua",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "markdown",
        "markdown_inline",
      },
      highlight = { enable = true }
    })
  end,
}
