-- plugins.lua
return {
	-- Mason and LSP integration
	{ "williamboman/mason.nvim", run = ":MasonUpdate" },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd" },
				automatic_installation = true,
			})
		end,
	},

	-- Neovim LSP configurations
	{ "neovim/nvim-lspconfig" },

	-- Completion and Snippets
	{ "hrsh7th/nvim-cmp", dependencies = { "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" } },

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	-- Add more Treesitter parsers
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"vim",
				"cpp", -- C++ parser
				"c", -- C parser
			},
		},
	},

	-- Telescope for fuzzy searching
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	-- Neogen for generating Doxygen comments
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter",
		config = function()
			require("neogen").setup({
				enabled = true,
				languages = {
					cpp = {
						template = {
							annotation_convention = "custom",
							custom = {
								{ nil, "/**", { no_results = true, type = { "func", "file" } } },
								{ nil, " * @file", { no_results = true, type = { "file" } } },
								{ nil, " * $1", { no_results = true, type = { "func", "file" } } },
								{ nil, " */", { no_results = true, type = { "func", "file" } } },
								{ nil, "", { no_results = true, type = { "file" } } },

								{ nil, "/**", { type = { "func" } } },
								{ nil, " * $1", { type = { "func" } } },
								{ nil, " *", { type = { "func" } } },
								{ "tparam", " * @tparam %s $1" },
								{ "parameters", " * @param %s $1" },
								{ "return_statement", " * @return $1" },
								{ nil, " */" },
							},
						},
					},
				},
			})

		end,
	},

	-- Fuzzy finder with fzf
	{
		"junegunn/fzf",
		run = function()
			vim.fn["fzf#install"]()
		end,
	},
	{ "junegunn/fzf.vim" },

	-- Autopairs for brackets and parentheses
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				-- Main options --
				style = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
				transparent = false, -- Show/hide background
				term_colors = true, -- Change terminal color as per the selected theme style
				ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
				cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

				-- toggle theme style ---
				toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
				toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

				-- Change code style ---
				-- Options are italic, bold, underline, none
				-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
				code_style = {
					comments = "italic",
					keywords = "none",
					functions = "none",
					strings = "none",
					variables = "none",
				},

				-- Lualine options --
				lualine = {
					transparent = false, -- lualine center bar transparency
				},

				-- Custom Highlights --
				colors = {}, -- Override default colors
				highlights = {}, -- Override highlight groups

				-- Plugins Config --
				diagnostics = {
					darker = true, -- darker colors for diagnostic
					undercurl = true, -- use undercurl instead of underline for diagnostics
					background = true, -- use background color for virtual text
				},
			})
		end,
	},
	{
		"chrisgrieser/nvim-rip-substitute",
		cmd = "RipSubstitute",
		keys = {
			{
				"<leader>fs",
				function()
					require("rip-substitute").sub()
				end,
				mode = { "n", "x" },
				desc = " rip substitute",
			},
		},
	},
	-- Allow moving lines up down left right
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.move").setup({
				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
					left = "",
					right = "",
					down = "<M-j>",
					up = "<M-k>",

					-- Move current line in Normal mode
					line_left = "",
					line_right = "",
					line_down = "<M-j>",
					line_up = "<M-k>",
				},
			})
		end,
	},
}
