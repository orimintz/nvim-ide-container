-- mason.lua

require("mason").setup()

-- LSP servers setup
require("mason-lspconfig").setup({
	ensure_installed = {
		"clangd", -- C++
		"bashls", -- Bash
		"pyright", -- Python
		"cmake", -- cmake
		"lua_ls", -- Lua (if you use Lua in config)
	},
	automatic_installation = true, -- Automatically install any LSP that is configured
})
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				clangd = {
					cmd = {
						"clangd",
						"--header-insertion=never",
						"--all-scopes-completion",
						"--background-index",
						"--pch-storage=disk",
						"--cross-file-rename",
						"--log=info",
						"--completion-style=detailed",
						"--enable-config",
						"--clang-tidy",
						"--offset-encoding=utf-16",
						"--fallback-style=llvm",
						"--function-arg-placeholders",
					},
					on_init = function(client)
						client.offset_encoding = "utf-8"
					end,
				},
			}

			local server = servers[server_name] or {}
			-- This handles overriding only values explicitly passed
			-- by the server configuration above. Useful when disabling
			-- certain features of an LSP (for example, turning off formatting for tsserver)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
})

-- Install formatters directly using Mason
local mason_registry = require("mason-registry")

-- List of formatters you want to ensure are installed
local formatters = {
	"clang-format", -- C++ formatter
	"jq", -- JSON formatter
	"black", -- Python formatter
	"codespell", -- Spell check
}

-- Ensure all formatters are installed
for _, tool in ipairs(formatters) do
	local p = mason_registry.get_package(tool)
	if not p:is_installed() then
		p:install() -- Install the formatter if it's not already installed
	end
end

-- Conform setup for formatters
require("conform").setup({
	formatters_by_ft = {
		cpp = { "clang_format" }, -- C++ formatter
		json = { "jq" }, -- JSON formatter
		python = { "black", "isort" }, -- Python formatters
	},
	-- Configure auto-format on save
	format_on_save = {
		lsp_fallback = true,
	},
})
