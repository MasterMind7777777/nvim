-- Configure vim-dadbod UI
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_auto_execute_table_helpers = 1

-- Setup completion
vim.cmd [[
  augroup DadbodSql
    autocmd!
    autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni
  augroup END
]]

