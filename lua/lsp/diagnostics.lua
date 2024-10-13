local function get_all_diagnostics()
    local all_diagnostics = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local diagnostics = vim.diagnostic.get(bufnr)
        for _, diagnostic in ipairs(diagnostics) do
            diagnostic.bufnr = bufnr
            table.insert(all_diagnostics, diagnostic)
        end
    end
    return all_diagnostics
end

local function open_diagnostics_buffer()
    local diagnostics = get_all_diagnostics()
    local lines = {}
    for _, diagnostic in ipairs(diagnostics) do
        local bufnr = diagnostic.bufnr
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local lnum = diagnostic.lnum + 1
        local message = diagnostic.message:gsub("\n", " ")
        table.insert(lines, string.format("%s:%d: %s", filename, lnum, message))
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_set_current_buf(buf)
end

vim.api.nvim_create_user_command('Diagnostics', open_diagnostics_buffer, {})

