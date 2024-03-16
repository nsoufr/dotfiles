local keymap = vim.keymap

-- General
keymap.mapleader = ","

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Telescope
local builtin = require('telescope.builtin')
keymap.set('n', '<leader>ff', builtin.find_files, {})
keymap.set('n', '<C-p>', builtin.git_files, {})
