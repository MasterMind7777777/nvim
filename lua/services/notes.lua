function note_active()
    local current_file = vim.fn.expand('%:p') -- Get the full path of the current file
    local active_directory = "/home/mastermind/Notes/active/"
    local main_directory = "/home/mastermind/Notes/"

    if string.find(current_file, active_directory) then
        print("File is already active.")
        return
    end

    local new_path = active_directory .. vim.fn.expand('%:t') -- target active directory + current filename
    os.execute("mv " .. current_file .. " " .. new_path)
    vim.cmd("e " .. new_path) -- re-edit the moved file
    os.execute("/home/mastermind/bash/notes/start_active_notes.sh &> /dev/null &")
end

function note_not_active()
    local current_file = vim.fn.expand('%:p') -- Get the full path of the current file
    local active_directory = "/home/mastermind/Notes/active/"
    local main_directory = "/home/mastermind/Notes/"

    if current_file == main_directory .. vim.fn.expand('%:t') then
        print("File is not active.")
        return
    end

    local new_path = main_directory .. vim.fn.expand('%:t') -- target main directory + current filename
    os.execute("mv " .. current_file .. " " .. new_path)
    vim.cmd("e " .. new_path) -- re-edit the moved file
    os.execute("/home/mastermind/bash/notes/start_active_notes.sh &> /dev/null &")
end

-- Define Vim commands
vim.cmd('command! NoteActive lua note_active()')
vim.cmd('command! NoteNotActive lua note_not_active()')
