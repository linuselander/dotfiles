local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Dynamically load all plugin folders
local plugin_dirs = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/plugins", "*", true, true)
local plugin_specs = {}

for _, dir in ipairs(plugin_dirs) do
  if vim.fn.isdirectory(dir) == 1 then
    local name = vim.fn.fnamemodify(dir, ":t")
    table.insert(plugin_specs, { import = "plugins." .. name })
  end
end

require("lazy").setup({
  spec = plugin_specs,
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

