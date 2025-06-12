return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      cs = { "csharpier" },
      python = { "black" },
    },
    formatters = {
      csharpier = {
        command = os.getenv("HOME") .. "/.dotnet/tools/csharpier",
        args = { "format", "$FILENAME" },
        stdin = false,
      },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
      end,
    })
  end,
}

