-- Global defaults
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.editorconfig = true
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

vim.cmd([[
	set rtp^="/Users/raf/.opam/default/share/ocp-indent/vim"
	]])

if vim.g.vscode then
	require("code")
else
	require("keymaps")
	require("neovim")
end
