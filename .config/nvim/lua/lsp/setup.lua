local M = {}

M.setup_diagnostics = function()
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = ">>",
      spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

function M.setup_lsp_servers()
  M.setup_diagnostics()

  local lspconfig = require("lspconfig")
  local capabilities = require("lsp.capabilities").capabilities
  local on_attach = require("lsp.on_attach").on_attach

  local config_path = vim.fn.stdpath("config") .. "/lua/lsp/servers"
  local files = vim.fn.glob(config_path .. "/*.lua", false, true)

  -- Ensure neodev is first if present
  table.sort(files, function(a, b)
      if a:match("neodev%.lua$") then return true end
      if b:match("neodev%.lua$") then return false end
      return a < b
  end)

  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    local ok, opts = pcall(require, "lsp.servers." .. name)

    if ok then
      if name == "neodev" and opts.setup then
          opts.setup()
      else
          opts.on_attach = opts.on_attach or on_attach
          opts.capabilities = opts.capabilities or capabilities
          lspconfig[name].setup(opts)
      end
    else
      vim.notify("Failed to load LSP config for: " .. name, vim.log.levels.ERROR)
    end
  end
end

function M.setup_lsp_dap()
  local dap_modules = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/lsp/dap", "*.lua", false, true)
  for _, file in ipairs(dap_modules) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    if name ~= "init" then
      require("lsp.dap." .. name)
    end
  end
end

return M

