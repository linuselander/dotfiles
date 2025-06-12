return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "csharpier",
        "lua-language-server",
        "pyright",
         -- you can add other tools here too
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000, -- ms
    })
  end,
}

