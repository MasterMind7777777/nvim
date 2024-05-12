
function _G.open_current_directory_in_new_nvim_window()
    -- Check if the current buffer is associated with a file
    if vim.fn.bufname('%') == '' then
        print("Buffer is not associated with a file.")
        return
    end

    local current_directory = vim.fn.expand('%:p:h') -- Get the full path of the current file's directory
    if current_directory == "" or current_directory == nil then
        print("Unable to determine current directory.")
        return
    end

    -- Use the -e flag for alacritty, run nvim, then drop to a shell
    local cmd = string.format('alacritty -e fish -c "nvim %s; exec fish " &', vim.fn.shellescape(current_directory))
    vim.fn.system(cmd)
end

-- Define the Newv command
vim.api.nvim_command('command! Newv lua _G.open_current_directory_in_new_nvim_window()')

