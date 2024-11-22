-- Global defaults
vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
	require("vscode")
else
	require("keymaps")
	require("neovim")
end
