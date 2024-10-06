-- keymaps.lua
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- LSP keymaps for navigation
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

-- Generate Doxygen comments with Neogen
map('n', '<leader>ng', ':lua require("neogen").generate()<CR>', opts)

-- Fuzzy search using Telescope
map('n', '<leader>ff', ':Telescope find_files<CR>', opts)

