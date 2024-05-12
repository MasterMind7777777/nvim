-- Path to the file where the global script saves the layout state
local layout_file_path = "/home/mastermind/temp/.time_toggle"

-- Function to get the current global keyboard layout from the file
local function trim(s)
  return s:match'^%s*(.*%S)' or ''
end

local function get_global_layout()
    local file = io.open(layout_file_path, "r")
    if file then
        local layout = file:read("*all")
        file:close()
        layout = trim(layout)  -- Trimming the layout string

        local chosen_layout = layout == "MOSCOW" and "ru" or "us"
        return chosen_layout
    end
    return "us" -- Default to US layout if the file doesn't exist or can't be read
end

-- Making the set_layout function globally accessible
_G.set_layout = function(layout)
    vim.fn.system("setxkbmap " .. layout)
end

_G.on_insert_enter = function()
    local global_layout = get_global_layout()
    set_layout(global_layout)
end

_G.on_insert_leave = function()
    set_layout("us")
end

_G.on_vim_leave = function()
    local global_layout = get_global_layout()
    _G.set_layout(global_layout)
end

-- Autocommands to manage the keyboard layout
vim.api.nvim_exec([[
    augroup KeyboardLayoutSwitcher
        autocmd!
        autocmd VimEnter * lua _G.set_layout('us')
        autocmd VimLeave * lua _G.on_vim_leave()
        autocmd InsertEnter * lua _G.on_insert_enter()
        autocmd InsertLeave * lua _G.on_insert_leave()
    augroup END
]], false)
