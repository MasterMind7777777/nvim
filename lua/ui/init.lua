-- Visual settings here
-- Enable true colors
vim.opt.termguicolors = true

vim.cmd[[colorscheme dracula]]
-- or
-- vim.cmd[[colorscheme dracula-soft]]


require('lualine').setup {
  options = { theme  = 'dracula' },
}


local _border = "single"
vim.diagnostic.config{
  float={border=_border}
}

require('ui.treesitter')  -- This will load UI
require('ui.dressing')
require('ui.telescope')
