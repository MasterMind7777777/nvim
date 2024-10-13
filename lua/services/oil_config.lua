require'nvim-web-devicons'.setup {
  default = true; -- globally enable default icons (default to false)
  color_icons = true; -- globally enable colored icons (default to true)
  default_symbol = ''; -- default symbol used if not specified (default to '?')
}


require("oil").setup({
  -- ... (other configurations)
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- ... (other configurations)
  },
  -- ... (other configurations)
})
