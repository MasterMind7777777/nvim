-- Download packer.nvim if not installed
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- Check if the installation path is empty
if fn.empty(fn.glob(install_path)) > 0 then
	-- If it is, clone the packer.nvim repository into the installation path
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	-- Add the packer.nvim package
	vim.api.nvim_command("packadd packer.nvim")
end

vim.opt.showmode = false

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 4 -- A tab is equal to 4 spaces
vim.opt.shiftwidth = 4 -- Indenting uses 4 spaces
vim.opt.softtabstop = 4 -- Let backspace delete 4 spaces
vim.opt.signcolumn = "yes"

-- Plugins
require("plugins") -- This will load plugins

-- plugin variables
vim.g.merginal_resizeWindowToBranchLen = 1

-- Visual
require("ui.init") -- This will load UI

-- Other configuration settings
vim.opt.number = true
-- swap manual handler
vim.opt.directory = "/home/mastermind/temp/nvim/swap"
vim.opt.shortmess:append("A")
vim.cmd([[
  autocmd BufReadPre * if file_readable(expand("<afile>:p") . ".swp") | set noswapfile | endif
  autocmd BufReadPost * set swapfile
]])

vim.g.numbertoggle_relative = 1
vim.o.clipboard = "unnamedplus"
vim.cmd("filetype plugin indent on")

require("lsp.init") -- This will load lsp

--require('services')  -- This will load plugins

require("remap") -- This will load key remaps
require("services.init")
