-- Setting the leader key
vim.g.mapleader = ' '
vim.keymap.set("n", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("v", "<Space>", "<Nop>", { noremap = true, silent = true })

-- Basic key mappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "gg", "gg0", { noremap = true })
vim.keymap.set("n", "<Leader>yy", ":%y<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>dp", ":%delete|normal! \"+P<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>lr', '<Cmd>LspRestart<CR>', { noremap = true, silent = true })


-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- Git
vim.keymap.set('n', '<leader>gs', ':G<CR>', { noremap = true, silent = true })

-- Commenting
require('nvim_comment').setup()
vim.keymap.set('n', '<Leader>co', ':CommentToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<Leader>co', ':CommentToggle<CR>', { noremap = true, silent = true })

-- Quickfix
vim.api.nvim_set_keymap('n', ']q', ':cnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[q', ':cprev<CR>', {noremap = true, silent = true})


-- Black Formatter
vim.keymap.set('n', '<Leader>bl', ':lua require("formatters.key_format").check_filetype_and_act()<CR>', { noremap = true, silent = true, nowait = true })

-- Notes
vim.keymap.set('n', '<Leader>na', ':NoteActive<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>nn', ':NoteNotActive<CR>', { noremap = true, silent = true })

