local keymap = vim.keymap

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Telescope
local builtin = require('telescope.builtin')
keymap.set('n', '<leader>p', builtin.find_files, {})
keymap.set('n', '<leader>.', builtin.git_files, {})

-- Neo-tree
keymap.set('n', '<C-e>', ":Neotree toggle<CR>")

-- Navigation
keymap.set('n', 'bp', ":bp<CR>")
keymap.set('n', 'bn', ":bn<CR>")
