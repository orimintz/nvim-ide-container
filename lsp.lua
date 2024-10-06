-- lsp.lua
local lspconfig = require('lspconfig')

-- Configure clangd with utf-16 offset encoding for better support with LSP
lspconfig.clangd.setup({
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
})

