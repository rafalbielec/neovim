-- Global defaults
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.editorconfig = true
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

if vim.g.vscode then
	require("vscode")
else
	require("keymaps")
	require("neovim")
end
