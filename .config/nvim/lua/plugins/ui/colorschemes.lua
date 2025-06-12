-- Set global UI options before any colorscheme is loaded
if vim.fn.has("termguicolors") == 1 then
  vim.o.termguicolors = true
end
vim.o.background = "dark"

return {
  'sainnhe/everforest',
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.everforest_background = 'hard'
    vim.g.everforest_enable_italic = false
    vim.cmd.colorscheme('everforest')
  end
}
