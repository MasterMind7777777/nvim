
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can define your own textobjects directly here
        ["af"] = "@function.outer", -- Select around function
        ["if"] = "@function.inner", -- Select inside function
      },
    },
  },
}


-- test function to test command
function test()
  print("Hello World")
  print("Hello World")
  print("Hello World")
  print("Hello World")
  print("Hello World")
  print("Hello World")
  print("Hello World")
end

