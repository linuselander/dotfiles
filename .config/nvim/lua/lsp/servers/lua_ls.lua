local util = require("lspconfig.util")
local capabilities = require("lsp.capabilities").capabilities
local on_attach = require("lsp.on_attach").on_attach

return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- for Neovim
      },
      diagnostics = {
        globals = { "vim" }, -- recognize the global `vim` variable
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- full runtime
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true, -- enable inline hints (optional)
      },
    },
  },
  root_dir = function(fname)
    return util.root_pattern(".git")(fname)
        or util.root_pattern("init.lua")(fname)
        or vim.fn.stdpath("config") -- fallback to your nvim config dir
  end,
  capabilities = capabilities,
  on_attach = on_attach,
}

