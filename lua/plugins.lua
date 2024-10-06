-- plugins.lua
return {
  -- Mason and LSP integration
  { 'williamboman/mason.nvim', run = ':MasonUpdate' },
  { 'williamboman/mason-lspconfig.nvim', config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'clangd' },
        automatic_installation = true,
      })
    end 
  },

  -- Neovim LSP configurations
  { 'neovim/nvim-lspconfig' },

  -- Completion and Snippets
  { 'hrsh7th/nvim-cmp', dependencies = { 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' } },

  -- Treesitter for code highlighting
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Telescope for fuzzy searching
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Neogen for generating Doxygen comments
  { 'danymat/neogen', dependencies = 'nvim-treesitter', config = function()
      require('neogen').setup({ enabled = true, languages = { cpp = { template = { annotation_convention = 'doxygen' } } } })
    end 
  },

  -- Fuzzy finder with fzf
  { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end },
  { 'junegunn/fzf.vim' },

  -- Autopairs for brackets and parentheses
  { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end },
}

