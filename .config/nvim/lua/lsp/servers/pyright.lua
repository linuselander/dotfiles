local capabilities = require("lsp.capabilities").capabilities
local on_attach = require("lsp.on_attach").on_attach

return {
  capabilities = capabilities,
  on_attach = on_attach,
}

