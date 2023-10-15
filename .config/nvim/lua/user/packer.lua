-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use({
      'ellisonleao/gruvbox.nvim',
      as = 'gruvbox',
      config = function()
          require("gruvbox").setup({
            italic = {
              strings = false,
              emphasis = false,
              comments = false,
              operators = false,
              folds = false,
            },
          })
          vim.cmd('colorscheme gruvbox')
      end
  })
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})
  -- LSP
  use('Hoffs/omnisharp-extended-lsp.nvim')
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional
      {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    }
  }
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  })
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }
  use {
    'nvim-tree/nvim-tree.lua',
    -- requires = {
    --   'nvim-tree/nvim-web-devicons', -- optional, for file icons
    -- },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]]
    })
  end}


  require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", "/path/to/omnisharp/OmniSharp.dll" },

    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').handler,
    },

    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = true,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = true,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = true,

    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    sdk_include_prereleases = false,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    analyze_open_documents_only = false,
  }

end)
