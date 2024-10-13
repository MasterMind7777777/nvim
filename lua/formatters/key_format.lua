local M = {}

local function check_filetype_and_act()
	local filetype = vim.bo.filetype

	if
		filetype == "javascript"
		or filetype == "typescript"
		or filetype == "javascriptreact"
		or filetype == "typescriptreact"
		or filetype == "html"
		or filetype == "css"
	then
		-- Format using prettier directly on the file and then reload the file
		vim.api.nvim_command("silent !prettier --write " .. vim.fn.shellescape(vim.fn.expand("%:p")))
		vim.api.nvim_command("edit!")
	elseif filetype == "python" then
		-- Format using ruff
		local filepath = vim.fn.shellescape(vim.fn.expand("%:p"))
		-- Run ruff check with the --fix option
		vim.api.nvim_command("silent !ruff check --fix " .. filepath)
		-- Run ruff-format
		vim.api.nvim_command("silent !ruff format " .. filepath)
		-- Refresh the buffer to reflect changes made by external commands
		vim.api.nvim_command("edit!")
	elseif filetype == "lua" then
		-- Format using stylua
		vim.api.nvim_command("silent !stylua " .. vim.fn.shellescape(vim.fn.expand("%:p")))
		vim.api.nvim_command("edit!")
	elseif filetype == "rust" then
		-- Format using rustfmt
		vim.api.nvim_command("silent !rustfmt " .. vim.fn.shellescape(vim.fn.expand("%:p")))
		vim.api.nvim_command("edit!")
	elseif filetype == "json" then
		-- Format JSON using jq
		vim.api.nvim_command("silent %!jq .")
	else
		print("Unsupported filetype")
		return
	end

	-- Make sure to redraw the screen to reflect the changes to the buffer
	vim.api.nvim_command("redraw")
end

M.check_filetype_and_act = check_filetype_and_act

return M
