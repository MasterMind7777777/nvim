_G.moveToNextEmptyLine = function()
   local current_line = vim.fn.line('.')
   local last_line = vim.fn.line('$')
   if current_line >= last_line then
      vim.fn.cursor(last_line, 0)  -- Stay at the last line if already there
      return
   end
   local found_block_end = false
   for i = current_line + 1, last_line do
      if vim.fn.getline(i):match("^%s*$") then
         if found_block_end then
            vim.fn.cursor(i - 1, 0)  -- Move to the last non-empty line of the block
            return
         end
      else
         found_block_end = true  -- We are inside a block of non-empty lines
      end
   end
   vim.fn.cursor(last_line, 0)  -- Move to the last line if no further empty lines are found
end

_G.moveToPreviousEmptyLine = function()
   local current_line = vim.fn.line('.')
   if current_line <= 1 then
      vim.fn.cursor(1, 0)  -- Stay at the first line if already there
      return
   end
   local found_non_empty_line = false
   for i = current_line - 1, 1, -1 do
      if vim.fn.getline(i):match("^%s*$") then
         if found_non_empty_line then
            vim.fn.cursor(i + 1, 0)  -- Move to the line after the empty line, marking the start of the block
            return
         end
      else
         found_non_empty_line = true  -- Found a non-empty line, marking the end of a previous block
      end
   end
   vim.fn.cursor(1, 0)  -- Move to the first line if no further empty lines are found
end

vim.api.nvim_set_keymap('n', '{', '<cmd>lua _G.moveToPreviousEmptyLine()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '}', '<cmd>lua _G.moveToNextEmptyLine()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '{', '<cmd>lua _G.moveToPreviousEmptyLine()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '}', '<cmd>lua _G.moveToNextEmptyLine()<CR>', { noremap = true, silent = true })
