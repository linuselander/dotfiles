return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-tool-installer").setup({
    ensure_installed = {
      "omnisharp",
      "csharpier",
      "lua-language-server",
      "pyright",
      "typescript-language-server",
      "angular-language-server",
      "prettier",
      "js-debug-adapter",
    },
    auto_update = false,
    run_on_start = true,
    start_delay = 3000, -- ms
    })
  end,
}

