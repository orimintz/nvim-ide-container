-- mason.lua
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'clangd' },  -- Automatically install clangd
  automatic_installation = true,    -- Automatically install any LSP that is configured
})

