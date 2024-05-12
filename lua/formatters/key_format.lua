local M = {}

local function check_filetype_and_act()
    local filetype = vim.bo.filetype

    if filetype == 'javascript' or filetype == 'typescript' or filetype == 'javascriptreact' or filetype == 'typescriptreact' or filetype == 'html' or filetype == 'css' then
        -- Format using prettier directly on the file and then reload the file
        vim.api.nvim_command('silent !prettier --write ' .. vim.fn.shellescape(vim.fn.expand('%:p')))
        vim.api.nvim_command('edit!')
    elseif filetype == 'python' or filetype == 'json' then
        -- Format using black
	    vim.api.nvim_command('silent %!black --line-length 79 - 2>/dev/null')
    elseif filetype == 'rust' then
        -- Format using rustfmt
        vim.api.nvim_command('silent !rustfmt ' .. vim.fn.shellescape(vim.fn.expand('%:p')))
        vim.api.nvim_command('edit!')
    else
        print("Unsupported filetype")
        return
    end

    -- Make sure to redraw the screen to reflect the changes to the buffer
    vim.api.nvim_command('redraw')
end

M.check_filetype_and_act = check_filetype_and_act

return M

