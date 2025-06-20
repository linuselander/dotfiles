local capabilities = require("lsp.capabilities").capabilities
local util = require("lspconfig/util")

local dotnet_root_pattern = util.root_pattern("*.sln", "*.csproj")

-- === .NET PROJECT-SPECIFIC SETTINGS ===
vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if dotnet_root_pattern(vim.fn.getcwd()) then
      vim.cmd("compiler dotnet")
    end
  end,
})

-- === LSP CONFIG FOR OMNISHARP ===
return {
  cmd = {
    "dotnet",
    vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.dll",
    "--languageserver",
    "--hostPID", tostring(vim.fn.getpid()),
  },
  capabilities = capabilities,
  root_dir = dotnet_root_pattern,
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
}
