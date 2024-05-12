local nvim_comment = require('nvim_comment')
local ts_context_commentstring = require('ts_context_commentstring')

ts_context_commentstring.setup({
    enable_autocmd = false,
})

nvim_comment.setup({
  marker_padding = true,
  comment_empty = false,
  create_mappings = true,
  line_mapping = "gcc",
  operator_mapping = "gc",
  hook = function()
    ts_context_commentstring.update_commentstring()
  end,
})

