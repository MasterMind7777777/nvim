require('copilot').setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = {
    ["."] = true,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})



local copilot_chat = require("CopilotChat")
local select = require('CopilotChat.select')
copilot_chat.setup({
	debug = false,
	show_help = "yes",
	prompts = {
		Explain = "Explain how it works by English language.",
		Review = "Review the following code and provide concise suggestions.",
		Tests = "Briefly explain how the selected code works, then generate unit tests.",
		Refactor = "Refactor the code to improve clarity and readability.",
	},
	build = function()
		vim.notify(
			"Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
	end,
	event = "VeryLazy",
	dependencies = {
		{ "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
		{ "nvim-lua/plenary.nvim" }
	},
	mappings = {
		complete = {
			detail = 'Use @<Tab> or /<Tab> for options.', -- Additional detail provided as per your format
			insert = '<Tab>',
		},
		close = {
			normal = 'q',
		},
		reset = {
			normal = '<C-l>',
			insert = '<C-l>', -- Kept the same for both normal and insert modes as per your structure
		},
		submit_prompt = {
			normal = '<CR>',
			insert = '<C-m>', -- Assuming <C-m> as the insert mode equivalent for submitting prompts
		},
		accept_diff = {
			normal = '<C-a>', -- Original mapping, retained in normal mode
			insert = '<C-a>', -- New insert mode mapping, assuming you want <C-y> for both modes
		},
		show_diff = {
			normal = '<C-s>', -- Changed from 'gd' to maintain original functionality
			-- 'gd' could be a typo or a new desired mapping. If 'gd' was intentional, replace '<C-d>' with 'gd'.
		},
		show_system_prompt = {
			normal = 'gp', -- New mapping, no direct counterpart in the original
		},
		show_user_selection = {
			normal = 'gs', -- New mapping, no direct counterpart in the original
		},
	},
})


vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
	copilot_chat.ask(args.args, { selection = select.visual })
end, { nargs = '*', range = true })

vim.api.nvim_create_user_command("CopilotChatInline", function(args)
	copilot_chat.ask(args.args, {
		selection = select.visual,
		window = {
			layout = "float",
			relative = "cursor",
			width = 1,
			height = 1,
			row = 1,
		},
	})
end, { nargs = "*", range = true })

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "copilot-*",
	callback = function()
		vim.opt_local.relativenumber = true
		vim.opt_local.number = true

		-- Get current filetype and set it to markdown if the current filetype is copilot-chat
		local ft = vim.bo.filetype
		if ft == "copilot-chat" then
			vim.bo.filetype = "markdown"
		end
	end,
})

vim.keymap.set("n", "<leader>cc",  ':CopilotChatInline<CR>i', { remap=false })
vim.keymap.set("v", "<leader>cc",  ":CopilotChatInline ", { remap=false })

vim.keymap.set("n", "<leader>ce",  ':CopilotChatExplain<CR>', { remap=false })
vim.keymap.set("v", "<leader>ce",  "y<CMD>CopilotChatExplain<CR>", { remap=false })
vim.keymap.set("n", "<leader>ct",  ':CopilotChatTests<CR>', { remap=false })

vim.keymap.set("n", "<leader>cd",  ':CopilotChatFixDiagnostic<CR>', { remap=false })
vim.keymap.set("n", "<leader>cr",  ':CopilotChatReset<CR>', { remap=false })

