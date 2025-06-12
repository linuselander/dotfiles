local capabilities = require("lsp.capabilities").capabilities
local util = require("lspconfig/util")

return {
    cmd = {
        "dotnet",
        vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.dll",
        "--languageserver",
        "--hostPID", tostring(vim.fn.getpid()),
    },
  capabilities = capabilities,
  root_dir = util.root_pattern("*.sln", "*.csproj"),
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
}
