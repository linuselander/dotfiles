local capabilities = require("lsp.capabilities").capabilities
local on_attach = require("lsp.on_attach").on_attach
local util = require("lspconfig/util")

return {
  cmd = {
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    vim.fn.getcwd() .. "/node_modules",
    "--ngProbeLocations",
    vim.fn.getcwd() .. "/node_modules",
  },
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
  root_dir = util.root_pattern("angular.json", "project.json"),
  capabilities = capabilities,
  on_attach = on_attach,
}

