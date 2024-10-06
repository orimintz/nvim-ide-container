-- mason.lua

require('mason').setup()

-- LSP servers setup
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',      -- C++
    'bashls',      -- Bash
    'json-lsp',      -- JSON
    'pyright',     -- Python
    'lua_ls',      -- Lua (if you use Lua in config)
    'grammarly',   -- A language server implementation on top of Grammarly's SDK.
  },
  automatic_installation = true, -- Automatically install any LSP that is configured
})

-- Install formatters directly using Mason
require('mason').setup({
  ensure_installed = {
    "clang-format",    -- C++ formatter
    "shfmt",           -- Bash formatter
    "jq",              -- JSON formatter
    "black",           -- Python formatter
  },
  automatic_installation = true,
})


-- Conform setup for formatters
require("conform").setup({
  formatters_by_ft = {
    cpp = { "clang_format" },      -- C++ formatter
    bash = { "shfmt" },            -- Bash formatter
    json = { "jq" },               -- JSON formatter
    python = { "black", "isort" }, -- Python formatters
  },
  -- Configure auto-format on save
  format_on_save = {
    lsp_fallback = true,
  },
})
