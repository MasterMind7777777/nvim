local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- Function to send results to quickfix list, adjusted for correct context usage
local function send_to_qflist(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    actions.smart_send_to_qflist(prompt_bufnr, picker:get_multi_selection())
end

-- Customize Telescope defaults to include sending to quickfix list
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-q>"] = send_to_qflist,  -- From insert mode in Telescope UI
            },
            n = {
                ["<C-q>"] = send_to_qflist,  -- From normal mode in Telescope UI
            },
        },
    },
}

-- Key mappings for normal mode
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

