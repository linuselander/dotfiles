return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        layout_config = {
          horizontal = { preview_width = 0.6 },
        },
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
      },
      pickers = {
        find_files = { theme = "dropdown" },
        buffers = { theme = "dropdown" },
      },
    })

    -- Telescope keymaps
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
    keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
    keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
    keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
    keymap("n", "<leader>ld", "<cmd>Telescope diagnostics<cr>", opts)
    keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", opts)
    keymap("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", opts)
    keymap("n", "<leader>li", "<cmd>Telescope lsp_implementations<cr>", opts)
    keymap("n", "<leader>lD", "<cmd>Telescope lsp_definitions<cr>", opts)

  end,
}
