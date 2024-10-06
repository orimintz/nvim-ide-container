-- mason.lua

require('mason').setup()

-- LSP servers setup
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',      -- C++
    'bashls',      -- Bash
    'jsonls',      -- JSON
    'pyright',     -- Python
    'lua_ls',      -- Lua (if you use Lua in config)
  },
  automatic_installation = true, -- Automatically install any LSP that is configured
})

-- Install formatters via mason
require("mason-tool-installer").setup({
  ensure_installed = {
    -- C++ tools
    "clang-format",    -- C++ formatter

    -- Bash tools
    "shfmt",           -- Bash formatter

    -- JSON tools
    "jq",              -- JSON formatter

    -- Python tools
    "black",           -- Python formatter
    "isort",           -- Python import sorter
  },
  automatic_installation = true, -- Auto-install specified tools
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
