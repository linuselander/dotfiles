-- Set mapleader early, before plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load plugin and config
require("config.lazy")
require("config.keymaps")

-- vim.g.loaded_netrw = 0
-- vim.g.loaded_netrwPlugin = 0
vim.cmd("let g:netrw_liststyle = 3")
vim.cmd("let g:netrw_banner = 0 ")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Enable folding ( setup in nvim-ufo )
vim.o.foldenable = true     -- Enable folding by default
vim.o.foldmethod = "manual" -- Default fold method (change as needed)
vim.o.foldlevel = 99        -- Open most folds by default
vim.o.foldcolumn = "0"

-- backspace
vim.opt.backspace = { "start", "eol", "indent" }

--split windows
vim.opt.splitright = true --split vertical window to the right
vim.opt.splitbelow = true --split horizontal window to the bottom

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

-- clipboard
vim.opt.clipboard:append("unnamedplus") --use system clipboard as default
vim.opt.hlsearch = true

-- for easy mouse resizing, just incase
vim.opt.mouse = "a"

-- gets rid of line with white spaces
vim.g.editorconfig = true


-- Function for toggling Lexplore
-- Initialize global flag
if _G.lexplore_open == nil then
  _G.lexplore_open = false
end

-- Function to toggle Lexplore
function _G.lexplore_toggle()
  if _G.lexplore_open then
    vim.cmd("Lexplore!")
    _G.lexplore_open = false
  else
    vim.cmd("30Lexplore %:p:h")
    _G.lexplore_open = true
  end
end

-- Keybinding for <leader>e
vim.keymap.set("n", "<leader>e", _G.lexplore_toggle, { noremap = true, silent = true })

-- Autocommand to unset lexplore_open when netrw buffer is closed
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "netrw" then
      _G.lexplore_open = false
    end
  end
})

-- === Backup, Swap, and Undo Settings ===

-- Set base path for custom storage
local nvim_data_path = vim.fn.stdpath("data") -- usually ~/.local/share/nvim
local backup_dir = nvim_data_path .. "/backups//"
local swap_dir   = nvim_data_path .. "/swaps//"
local undo_dir   = nvim_data_path .. "/undos//"
local session_dir = nvim_data_path .. "/sessions/"

-- Create directories if they don't exist
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

ensure_dir(backup_dir)
ensure_dir(swap_dir)
ensure_dir(undo_dir)
ensure_dir(session_dir) -- Configured in auto-session.lua

-- Enable backups, swaps, and persistent undo
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.swapfile = true
vim.opt.undofile = true

-- Use full-path-style encoded filenames for uniqueness
vim.opt.backupdir = backup_dir
vim.opt.directory = swap_dir
vim.opt.undodir = undo_dir
