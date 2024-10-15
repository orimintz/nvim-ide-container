-- mason.lua

require('mason').setup()

-- LSP servers setup
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',      -- C++
    'bashls',      -- Bash
    'pyright',     -- Python
    'cmake',       -- cmake
    'lua_ls',      -- Lua (if you use Lua in config)
  },
  automatic_installation = true, -- Automatically install any LSP that is configured
    handlers = {
        ["clangd"] = function()
            require('lspconfig').clangd.setup({
                capabilities = {
                    offsetEncoding = { "utf-16" },
                },
                cmd = {
                    "clangd",
                    "--header-insertion=never",
                },
            })
        end,
    },
})

-- Install formatters directly using Mason
local mason_registry = require("mason-registry")

-- List of formatters you want to ensure are installed
local formatters = {
    "clang-format",    -- C++ formatter
    "shfmt",           -- Bash formatter
    "jq",              -- JSON formatter
    "black",           -- Python formatter
    "codespell",           -- Spell check
}

-- Ensure all formatters are installed
for _, tool in ipairs(formatters) do
  local p = mason_registry.get_package(tool)
  if not p:is_installed() then
    p:install()   -- Install the formatter if it's not already installed
  end
end

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


